//
//  CameraPreview.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 05/11/21.
//
// ref: https://www.raywenderlich.com/19454476-vision-tutorial-for-ios-detect-body-and-hand-pose#toc-anchor-001

// 1
import UIKit
import AVFoundation

final class MovementTrackingCameraPreview: UIView {
  // 2
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }
  
  // 3
  var previewLayer: AVCaptureVideoPreviewLayer {
    layer as! AVCaptureVideoPreviewLayer
  }
}
