//
//  WallDetectionViewController.swift
//  TheOfficers
//
//  Created by João Pedro Picolo on 04/11/21.
//

import UIKit
import ARKit
import SnapKit

enum AppState: Int16 {
  case lookingForWall   // Just starting out; no surfaces detected yet
  case printed          // Image was placed on wall
}

// MARK: - View Controller
class WallDetectionViewController: UIViewController {
  lazy var ARView: ARSCNView = {
    let sceneView = ARSCNView()
    sceneView.delegate = self
    sceneView.automaticallyUpdatesLighting = true
    sceneView.preferredFramesPerSecond = 60
    sceneView.antialiasingMode = .multisampling2X
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

    sceneView.layer.cornerRadius = 30
    sceneView.layer.borderWidth = 0.1
    sceneView.layer.masksToBounds = true

    return sceneView
  }()
  
  lazy var ARConfig: ARConfiguration = {
    let config = ARWorldTrackingConfiguration()
    config.worldAlignment = .camera
    config.planeDetection = [.vertical]
    config.isLightEstimationEnabled = true
    
    return config
  }()

  lazy var snapshotView: UIImageView = {
    let view = UIImageView()
    
    view.layer.cornerRadius = 30
    view.layer.borderWidth = 0.1
    view.layer.masksToBounds = true
    
    return view
  }()
  
  lazy var imageCaptureButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 58, weight: .regular, scale: .large)
    button.setImage(UIImage(systemName: "largecircle.fill.circle", withConfiguration: config), for: .normal)
    button.tintColor = .white
    
    return button
  }()
  
  lazy var downloadButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
    button.setImage(UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: config), for: .normal)
    button.tintColor = UIColor(named: "pink")
    
    return button
  }()
  
  var existingPlanes = [SCNNode]()
  var appState: AppState = .lookingForWall
  
  var buttonFilled: ButtonFilled = .createButton(text: "Continue", buttonImage: "arrow.forward")
  var buttonOutlined: ButtonOutlined = .createButton(text: "Click on the choosen wall to \n see your art on it")


  // -> View initializers / events
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    if ARWorldTrackingConfiguration.isSupported {
        ARView.session.run(ARConfig)
    } else {
        print("Sorry, your device doesn't support ARKit")
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ARView.session.pause()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupHierarchy()
    setupConstraints()
    initGestureRecognizers()
  }
  
  func setupHierarchy() {
    view.backgroundColor = UIColor(named: "backgroundGray")
    
    view.addSubview(ARView)
    view.addSubview(snapshotView)
    view.addSubview(imageCaptureButton)
    view.addSubview(downloadButton)
    view.addSubview(buttonOutlined)
    view.addSubview(buttonFilled)
  }
  
  func setupConstraints() {
    ARView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview().offset(60)
      make.bottom.equalToSuperview().offset(-130)
    }
    
    snapshotView.alpha = 0
    snapshotView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview().offset(60)
      make.bottom.equalToSuperview().offset(-130)
    }
    
    buttonOutlined.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(730)
      make.centerX.equalToSuperview()
    }

    buttonFilled.alpha = 0
    buttonFilled.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(730)
      make.centerX.equalToSuperview()
    }

    imageCaptureButton.alpha = 0
    imageCaptureButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(620)
      make.centerX.equalToSuperview()
    }
    
    downloadButton.alpha = 0
    downloadButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(730)
      make.leading.equalTo(30)
    }
  }
}

// MARK: - Gesture Recognizers
extension WallDetectionViewController {
  func initGestureRecognizers() {
    ARView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleScreenTap)))
    imageCaptureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
    downloadButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
  }
  
  @objc
  func handleScreenTap(sender: UITapGestureRecognizer) {
    let location = sender.location(in: ARView)
    let results = ARView.hitTest(location, options: [SCNHitTestOption.searchMode : 1])

    let planeNode = results.first?.node
    
    if planeNode != nil {
      // Only attempts to place image in the case the node was detect, otherwise the scene breaks
      if existingPlanes.contains(planeNode!.parent!) {
        for plane in existingPlanes {
          if plane != planeNode!.parent {
            // Removes AR Nodes that don't contain the clicked plane
            plane.parent?.removeFromParentNode()
          }
        }
        
        appState = .printed
        ARView.debugOptions = []

        
        planeNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "grafite")
        planeNode?.opacity = 1.0
        
        buttonOutlined.removeFromSuperview()
        buttonFilled.alpha = 1
        imageCaptureButton.alpha = 1
        
        UIView.animate(withDuration: 0.5) {
          self.buttonOutlined.alpha = 0
          self.buttonFilled.alpha = 1
          self.imageCaptureButton.alpha = 1
        }
        
        existingPlanes.removeAll()
        existingPlanes.append(planeNode!.parent!)
      }
    }
  }
  
  @objc
  func capturePhoto() {
    let scene = ARView.snapshot()
    snapshotView.image = scene
    
    UIView.animate(withDuration: 0.5) {
      self.snapshotView.alpha = 1
      self.downloadButton.alpha = 1
      self.imageCaptureButton.alpha = 0
    }
    
    // Adjusts button constraints
    buttonFilled.snp.updateConstraints { make in
      make.centerX.equalToSuperview().offset(30)
    }
  }
  
  @objc
  func savePhoto() {
    guard let image = snapshotView.image else { return }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
  }
}


// MARK: - Plane detection
extension WallDetectionViewController: ARSCNViewDelegate {
  // -> Detection
  // This delegate method gets called whenever the node for
  // a *new* AR anchor is added to the scene.
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    let plane = Plane(anchor: planeAnchor, in: ARView)
    
    if appState != .printed {
      // Remove any children this node may have.
      node.enumerateChildNodes { (childNode, _) in
        childNode.removeFromParentNode()
      }
      node.addChildNode(plane)
      existingPlanes.append(plane)
    }
  }

  // This delegate method gets called whenever the node for
  // an *existing* AR anchor is updated.
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
    guard let planeAnchor = anchor as? ARPlaneAnchor,
          let plane = node.childNodes.first as? Plane
    else { return }
    
    // Update extent visualization to the anchor's new bounding rectangle.
    if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
        extentGeometry.width = CGFloat(planeAnchor.extent.x)
        extentGeometry.height = CGFloat(planeAnchor.extent.z)
        plane.extentNode.simdPosition = planeAnchor.center
    }
  }
  
  // This delegate method gets called whenever the node corresponding to
  // an existing AR anchor is removed.
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    // We only want to deal with plane anchors.
    guard anchor is ARPlaneAnchor else { return }

    // Remove any children this node may have.
    node.enumerateChildNodes { (childNode, _) in
      childNode.removeFromParentNode()
    }
  }
  
  
  // -> AR configuration
  func resetARsession() {
    ARView.session.run(ARConfig, options: [.resetTracking, .removeExistingAnchors])
    appState = .lookingForWall
  }
  
  
  // -> AR session error management
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    resetARsession()
    ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
  }
}

