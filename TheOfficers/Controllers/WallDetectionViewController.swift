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
  case pointToWall      // Surfaces detected, but device is not pointing to any of them
  case readyToPrint     // Surfaces detected *and* device is pointing to at least one
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

    return sceneView
  }()
  
  lazy var ARConfig: ARConfiguration = {
    let config = ARWorldTrackingConfiguration()  // Use "6 degrees of freedom" tracking
    config.worldAlignment = .gravity
    config.planeDetection = [.vertical]
    config.isLightEstimationEnabled = true
    
    return config
  }()
  
  var appState: AppState = .lookingForWall
  var statusMessage = ""
  var trackingStatus = ""
  var existingPlanes = [SCNNode]()
  

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

    setupARView()
    initGestureRecognizers()
  }
  
  func setupARView() {
    view.addSubview(ARView)
    ARView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func resetARsession() {
    ARView.session.run(ARConfig, options: [.resetTracking, .removeExistingAnchors])
    appState = .lookingForWall
  }
  
  // -> Adding picture
  func initGestureRecognizers() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap))
    ARView.addGestureRecognizer(tapGestureRecognizer)
  }

  @objc func handleScreenTap(sender: UITapGestureRecognizer) {
    let location = sender.location(in: ARView)
    let results = ARView.hitTest(location, options: [SCNHitTestOption.searchMode : 1])

    let planeNode = results.first?.node

    if planeNode != nil {
      planeNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "grafite")
      planeNode?.opacity = 1.0
      appState = .printed
      
      for plane in existingPlanes {
        if plane != planeNode!.parent {
          // Removes AR Nodes that don't contain the clicked plane
          plane.parent?.removeFromParentNode()
        }
      }
      
      existingPlanes = []
      existingPlanes.append(planeNode!.parent!)
    }
  }
}


// MARK: - App status
extension WallDetectionViewController {
  // This method is called once per frame, and we use it to perform tasks
  // that we want performed constantly.
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.main.async {
      self.updateAppState()
      self.updateStatusText()
    }
  }

  // Updates the app status, based on whether any of the detected planes
  // are currently in view.
  func updateAppState() {
    guard appState == .pointToWall ||
      appState == .readyToPrint
      else {
        return
    }

    if isAnyPlaneInView() {
      appState = .readyToPrint
    } else {
      appState = .pointToWall
    }
  }

  // Update the status text at the top of the screen whenever
  // the AR camera tracking state changes.
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
    case .notAvailable:
      trackingStatus = "For some reason, augmented reality tracking isn’t available."
    case .normal:
      trackingStatus = ""
    case .limited(let reason):
      switch reason {
      case .excessiveMotion:
        trackingStatus = "You’re moving the device around too quickly. Slow down."
      case .insufficientFeatures:
        trackingStatus = "I can’t get a sense of the room. Is something blocking the rear camera?"
      case .initializing:
        trackingStatus = "Initializing — please wait a moment..."
      case .relocalizing:
        trackingStatus = "Relocalizing — please wait a moment..."
      @unknown default:
        trackingStatus = "Error — please wait a moment..."
      }
    }
  }

  // Updates the status text displayed at the top of the screen.
  func updateStatusText() {
    switch appState {
    case .lookingForWall:
      statusMessage = "Scan the room with your device until the yellow dots appear."
      ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    case .pointToWall:
      statusMessage = "Point your device towards one of the detected surfaces."
      ARView.debugOptions = []
    case .readyToPrint:
      statusMessage = "Look at walls to place posters."
      ARView.debugOptions = []
    case .printed:
      statusMessage = "Image was placed on image."
      ARView.debugOptions = []
    }
  }

  // We can’t check *every* point in the view to see if it contains one of
  // the detected planes. Instead, we assume that the planes that will be detected
  // will intersect with at least one point on a 5*5 grid spanning the entire view.
  func isAnyPlaneInView() -> Bool {
    let screenDivisions = 5 - 1
    let viewWidth = view.bounds.size.width
    let viewHeight = view.bounds.size.height

    for y in 0...screenDivisions {
      let yCoord = CGFloat(y) / CGFloat(screenDivisions) * viewHeight
      for x in 0...screenDivisions {
        let xCoord = CGFloat(x) / CGFloat(screenDivisions) * viewWidth
        let point = CGPoint(x: xCoord, y: yCoord)

        // Perform hit test for planes.
        let hitTest = ARView.hitTest(point, options: [SCNHitTestOption.searchMode : 1])
        if !hitTest.isEmpty {
          return true
        }

      }
    }
    return false
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
  
  
  // -> AR session error management
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
    trackingStatus = "AR session failure: \(error)"
  }

  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    trackingStatus = "AR session was interrupted!"
  }

  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    trackingStatus = "AR session interruption ended."
    resetARsession()
  }
}


// MARK: - Utility methods
// Extend the "+" operator so that it can add two SCNVector3s together.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3(left.x + right.x,
                    left.y + right.y,
                    left.z + right.z)
}
