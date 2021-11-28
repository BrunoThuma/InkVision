//
//  MapPinMock.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//  Credits to Vinicius Couto

import MapKit

#if DEBUG
    extension MapPinAnnotation {
        static func fixtureArt1(title: String = "Brunin Gameplays",
                                type: MapPinType = .art,
                                coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                                    latitude: -25.429981,
                                    longitude: -49.2972083))
            -> MapPinAnnotation {
            MapPinAnnotation(title: title, coordinate: coordinate, type: type)
        }

        static func fixtureArt2(title: String = "PUCPR",
                                   type: MapPinType = .art,
                                   coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                                    latitude: -25.4525344,
                                    longitude: -49.2513096))
            -> MapPinAnnotation {
            MapPinAnnotation(title: title, coordinate: coordinate, type: type)
        }
        
        static func fixtureArt3(title: String = "Spot da massa",
                                type: MapPinType = .art,
                                coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                                    latitude: -25.5066690,
                                    longitude: -49.2333497))
            -> MapPinAnnotation {
            MapPinAnnotation(title: title, coordinate: coordinate, type: type)
        }
    }
#endif
