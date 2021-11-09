//
//  MovementTrackingViewController.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 04/11/21.
//

import UIKit
import AVFoundation
import Vision

class MovementTrackingViewController: UIViewController {
    
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        // Create a request for detecting human hands.
        let request = VNDetectHumanHandPoseRequest()

        // Set the maximum number of hands
        request.maximumHandCount = 1
        return request
    }()
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    private var cameraFeedSession: AVCaptureSession?

    private var cameraView: MovementTrackingCameraPreview { view as! MovementTrackingCameraPreview }
    
    override func loadView() {
        view = MovementTrackingCameraPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            // 1
            if cameraFeedSession == nil {
                // 2
                try setupAVSession()
                // 3
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }

            // 4
            cameraFeedSession?.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }

    // 5
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }

    func setupAVSession() throws {
        // Check if the device has a front-facing camera.
        // If it doesn’t, throw an error.
        guard let videoDevice = AVCaptureDevice.default(
        .builtInWideAngleCamera,
        for: .video,
        position: .front)
        else {
            throw AppError.noCamera
//            print("Could not find a front facing camera.")
        }

        // Check if you can use the camera to create a capture device input.
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            throw AppError.noDeviceInput
//            print("Could not create video device input.")
        }

        // Create a capture session and start configuring
        // it using the high quality preset.
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high

        // Check if the session can integrate the capture device input
        guard session.canAddInput(deviceInput) else {
            throw AppError.noDeviceOutput
//            print("Could not add video device input to the session")
        }
        session.addInput(deviceInput)

        // Create a data output and add it to the session.
        // The data output will take samples of images from
        // the camera feed and provide them in a delegate
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
//            throw AppError.captureSessionSetup(
//                reason: "Could not add video data output to the session"
//            )
            print("Could not add video data output to the session")
        }

        // Finish configuring the session and assign it to the property.
        session.commitConfiguration()
        cameraFeedSession = session
    }
}


extension MovementTrackingViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        print("Function called")
        // Called whenever a sample is available
        let handler = VNImageRequestHandler(
        cmSampleBuffer: sampleBuffer,
        orientation: .up,
        options: [:]
        )

        do {
            // Perform the request. If there are any errors, this method throws them, so it’s in a do-catch block.
            try handler.perform([handPoseRequest])

            // Get the detection results, using the request’s results
            guard
              let results = handPoseRequest.results?.prefix(2),
              !results.isEmpty
            else {
              return
            }

            print(results)
        } catch {
            // If the request fails, it means something bad happened.
            cameraFeedSession?.stopRunning()
        }
    }
}


/*
 func handle(error: AppError) {
     switch error {
         case .captureSessionSetup(reason: .notSupported): // Mostra um erro
         case .captureSessionSetup(reason: .noCamera): // Mostra outro erro
         case .captureSessionSetup(reason: .unknown): // Mostra mais um erro diferente
         case .defaultError: // Faz outra coisa
     }
 }
*/
