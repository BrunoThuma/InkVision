//
//  Utilities.swift
//  InkVision
//
//  Created by João Pedro Picolo on 19/11/21.
//

import ARKit

// Extend the "+" operator so that it can add two SCNVector3s together.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3(left.x + right.x,
                    left.y + right.y,
                    left.z + right.z)
}
