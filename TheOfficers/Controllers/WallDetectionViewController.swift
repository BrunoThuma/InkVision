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

    return sceneView
  }()
  
  lazy var ARConfig: ARConfiguration = {
    let config = ARWorldTrackingConfiguration()  // Use "6 degrees of freedom" tracking
    config.worldAlignment = .camera
    config.planeDetection = [.vertical]
    config.isLightEstimationEnabled = true
    
    return config
  }()
  
  var appState: AppState = .lookingForWall
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
      for plane in existingPlanes {
        if plane != planeNode!.parent {
          // Removes AR Nodes that don't contain the clicked plane
          plane.parent?.geometry?.firstMaterial?.normal.contents = nil
          plane.parent?.geometry?.firstMaterial?.diffuse.contents = nil
          plane.parent?.removeFromParentNode()
        }
      }
      
      appState = .printed
      ARView.debugOptions = []
      
      planeNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "grafite")
      planeNode?.opacity = 1.0

      existingPlanes.removeAll()
      existingPlanes.append(planeNode!.parent!)
    }
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
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    resetARsession()
    ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
  }
}


// MARK: - Utility methods
// Extend the "+" operator so that it can add two SCNVector3s together.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3(left.x + right.x,
                    left.y + right.y,
                    left.z + right.z)
}
