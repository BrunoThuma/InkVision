/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app's main view controller object.
*/

import UIKit
import AVFoundation
import Vision

class MotionDetectionViewController: UIViewController {

    private var motionDetectionView: MotionDetectionView! //{ view as! motionDetectionView }
    private lazy var finishArtButton: ButtonFilled = .createButton(text: "Generate art", buttonImage: nil)
    private lazy var nextButton: ButtonFilled = .createButton(text: "", buttonImage: "arrow.forward")
    private var draw: DrawView?
    private var flag = 0
    private var cgPoints: [CGPoint] = []
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    private let drawOverlay = CAShapeLayer()
    private let drawPath = MyBezierPath()
    private var evidenceBuffer = [HandGestureProcessor.PointsPair]()
    private var lastDrawPoint: CGPoint?
    private var isFirstSegment = true
    private var lastObservationTimestamp = Date()
    
    private var gestureProcessor = HandGestureProcessor()
    
    weak var delegate: MapViewControllerDelegate?
    
    override func loadView() {
        view = MotionDetectionView()
        
        finishArtButton.addTarget(self,
                                  action: #selector(finishDrawingTapped),
                                  for: .touchUpInside)
        
        nextButton.addTarget(self,
                                  action: #selector(nextSceneTapped),
                                  for: .touchUpInside)
        
        setupHierarchy()
        setupConstraints()
    }

    override func viewDidLoad() {
        motionDetectionView = (view as! MotionDetectionView)
        
        super.viewDidLoad()
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 5
        drawOverlay.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0.5).cgColor
        drawOverlay.strokeColor = #colorLiteral(red: 0.6, green: 0.1, blue: 0.3, alpha: 1).cgColor
        drawOverlay.fillColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0).cgColor
        drawOverlay.lineCap = .round
        view.layer.addSublayer(drawOverlay)
        // This sample app detects one hand only.
        handPoseRequest.maximumHandCount = 1
        // Add state change handler to hand gesture processor.
        gestureProcessor.didChangeStateClosure = { [weak self] state in
            self?.handleGestureStateChange(state: state)
        }
        // Add double tap gesture recognizer for clearing the draw path.
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(recognizer)
//        motionDetectionView.addTargetToFinishButton(self, action: #selector(finishDrawingTapped))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        draw = DrawView(frame: self.view.bounds)
        view.addSubview(draw!)
        view.bringSubviewToFront(finishArtButton)
        view.bringSubviewToFront(nextButton)
        do {
            if cameraFeedSession == nil {
                motionDetectionView.previewLayer.videoGravity = .resizeAspectFill
                try setupAVSession()
                motionDetectionView.previewLayer.session = cameraFeedSession
            }
            cameraFeedSession?.startRunning()
        } catch {
            AppError.display(error, inViewController: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    private func setupHierarchy() {
        view.addSubview(finishArtButton)
        view.addSubview(nextButton)
    }

    private func setupConstraints() {
        finishArtButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-41)
        }
        
        nextButton.alpha = 0
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.centerX.equalToSuperview().offset(130)
            make.bottomMargin.equalToSuperview().offset(-41)
        }
    }
    
    func setupAVSession() throws {
        // Select a front facing camera, make an input.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.")
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // Add a video input.
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        session.commitConfiguration()
        cameraFeedSession = session
}
    
    func processPoints(thumbTip: CGPoint?, indexTip: CGPoint?) {
        // Check that we have both points.
        guard let thumbPoint = thumbTip, let indexPoint = indexTip else {
            // If there were no observations for more than 2 seconds reset gesture processor.
            if Date().timeIntervalSince(lastObservationTimestamp) > 2 {
                gestureProcessor.reset()
            }
            motionDetectionView.showPoints([], color: .clear)
            return
        }
        
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let previewLayer = motionDetectionView.previewLayer
        let thumbPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbPoint)
        let indexPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexPoint)
        
        // Process new points
        gestureProcessor.processPointsPair((thumbPointConverted, indexPointConverted))
    }
    
    private func handleGestureStateChange(state: HandGestureProcessor.State) {
        let pointsPair = gestureProcessor.lastProcessedPointsPair
        var tipsColor: UIColor
        switch state {
        case .possiblePinch, .possibleApart:
            // We are in one of the "possible": states, meaning there is not enough evidence yet to determine
            // if we want to draw or not. For now, collect points in the evidence buffer, so we can add them
            // to a drawing path when required.
            evidenceBuffer.append(pointsPair)
            tipsColor = .orange
        case .pinched:
            // We have enough evidence to draw. Draw the points collected in the evidence buffer, if any.
            for bufferedPoints in evidenceBuffer {
                updatePath(with: bufferedPoints, isLastPointsPair: false)
            }
            // Clear the evidence buffer.
            evidenceBuffer.removeAll()
            // Finally, draw the current point.
            updatePath(with: pointsPair, isLastPointsPair: false)
            tipsColor = .green
        case .apart, .unknown:
            // We have enough evidence to not draw. Discard any evidence buffer points.
            evidenceBuffer.removeAll()
            // And draw the last segment of our draw path.
            updatePath(with: pointsPair, isLastPointsPair: true)
            tipsColor = .red
        }
        motionDetectionView.showPoints([pointsPair.thumbTip, pointsPair.indexTip], color: tipsColor)
    }
    
    private func updatePath(with points: HandGestureProcessor.PointsPair, isLastPointsPair: Bool) {
        // Get the mid point between the tips.
        let (thumbTip, indexTip) = points
        // drawPoint is the middle point between the thumb and the index
        let drawPoint = CGPoint.midPoint(p1: thumbTip, p2: indexTip)

        if isLastPointsPair {
            if let lastPoint = lastDrawPoint {
                // Add a straight line from the last midpoint to the end of the stroke.
                drawPath.addLine(to: lastPoint)
                
                cgPoints.append(lastPoint)
                
                showTrace()
                clearPreTrace()
            }
            // We are done drawing, so reset the last draw point.
            lastDrawPoint = nil
        } else {
            if lastDrawPoint == nil {
                // This is the beginning of the stroke.
                drawPath.move(to: drawPoint)
                cgPoints.append(drawPoint)
                isFirstSegment = true
            } else {
                let lastPoint = lastDrawPoint!
                // Get the midpoint between the last draw point and the new point.
                let midPoint = CGPoint.midPoint(p1: lastPoint, p2: drawPoint)
                if isFirstSegment {
                    // If it's the first segment of the stroke, draw a line to the midpoint.
                    cgPoints.append(midPoint)
                    drawPath.addLine(to: midPoint)
                    isFirstSegment = false
                } else {
                    // Otherwise, draw a curve to a midpoint using the last draw point as a control point.
                    if flag < 4 {
                        flag += 1
                    }
                    else {
                        cgPoints.append(midPoint)
                        flag = 0
                    }
                    drawPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)
                }
            }
            // Remember the last draw point for the next update pass.
            lastDrawPoint = drawPoint
        }
        // Update the path on the overlay layer.
        drawOverlay.path = drawPath.cgPath
    }
    
    @objc
    func finishDrawingTapped() {
        if nextButton.alpha == 0 {
            nextButton.alpha = 1
            
            finishArtButton.snp.updateConstraints { make in
                make.width.equalTo(260)
                make.centerX.equalToSuperview().offset(-40)
            }
        }

        showRandom()
    }
    
    @objc
    func nextSceneTapped() {
        delegate?.presentArtPreview(image: draw!.render())
        dismiss(animated: true, completion: nil)
    }
    
    func showRandom(){
        draw!.bShowRandom = true
        draw!.setNeedsDisplay()
    }
    
    func showTrace(){
        draw!.showPath = cgPoints
        cgPoints = []
        draw!.bShowPath = true
        draw!.setNeedsDisplay()
    }
    
    func clearScreen(){
        if let draw = draw {
            draw.bClear = true
            draw.setNeedsDisplay()
            
        }
        clearPreTrace()
    }
    
    func clearPreTrace(){
        evidenceBuffer.removeAll()
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
    
    @IBAction func handleGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        clearScreen()
    }
}

extension MotionDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var thumbTip: CGPoint?
        var indexTip: CGPoint?
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(thumbTip: thumbTip, indexTip: indexTip)
            }
        }

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            // Perform VNDetectHumanHandPoseRequest
            try handler.perform([handPoseRequest])
            // Continue only when a hand was detected in the frame.
            // Since we set the maximumHandCount property of the request to 1, there will be at most one observation.
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            // Get points for thumb and index finger.
            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
            // Look for tip points.
            guard let thumbTipPoint = thumbPoints[.thumbTip], let indexTipPoint = indexFingerPoints[.indexTip] else {
                return
            }
            // Ignore low confidence points.
            guard thumbTipPoint.confidence > 0.5 && indexTipPoint.confidence > 0.5 else {
                return
            }
            // Convert points from Vision coordinates to AVFoundation coordinates.
            thumbTip = CGPoint(x: thumbTipPoint.location.x, y: 1 - thumbTipPoint.location.y)
            indexTip = CGPoint(x: indexTipPoint.location.x, y: 1 - indexTipPoint.location.y)
        } catch {
            cameraFeedSession?.stopRunning()
            let error = AppError.visionError(error: error)
            DispatchQueue.main.async {
                error.displayInViewController(self)
            }
        }
    }
}

