//
//  UserLocationDelegate.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//

import MapKit

protocol UserLocationDelegate: AnyObject {
    func setLastKnownLocation(_ location: CLLocation)
}
