//
//  MapAdapterDelegate.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//

protocol MapAdapterDelegate: AnyObject {
    func willLocateUser()

    func locationTapped(type: MapPinType)
}
