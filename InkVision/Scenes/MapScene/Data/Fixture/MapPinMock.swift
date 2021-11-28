//
//  MapPinMock.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//  Credits to Vinicius Couto

import MapKit

#if DEBUG
    extension MapPinAnnotation {
        static func fixtureSpot(title: String = "Spot da massa",
                                type: MapPinType = .art,
                                coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -25.4174327,
                                                                                            longitude: -49.2690548))
            -> MapPinAnnotation {
            MapPinAnnotation(title: title, coordinate: coordinate, type: type)
        }

        static func fixtureStopper(title: String = "Stopper da massa",
                                   type: MapPinType = .art,
                                   coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -25.4525344,
                                                                                               longitude: -49.2513098))
            -> MapPinAnnotation {
            MapPinAnnotation(title: title, coordinate: coordinate, type: type)
        }
    }
#endif
