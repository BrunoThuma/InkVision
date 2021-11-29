//
//  MapAdapter.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//  Credits to Vinicius Couto

import MapKit

final class MapAdapter: NSObject, MKMapViewDelegate {
    // MARK: - Public attributes

    weak var delegate: MapAdapterDelegate?

    var currentSelection: MapPinAnnotation?

    // MARK: - Public methods

    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        delegate?.willLocateUser()
    }

    // Inspiration from https://stackoverflow.com/a/41342800
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // TODO: Define user icon or make this a guard
//        if let annotation = annotation as? MKUserLocation {
//            // User location annotation
//            let pin = mapView.view(for: annotation) as? MKPinAnnotationView
//                ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//            pin.image = UIImage(systemName: "questionmark")
//            return pin
//        }
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        // In case of custom user icon use else if let annotation ...
        if let annotation = annotation as? MapPinAnnotation {
            // Spots annotation
            let annotationIdentifier = annotation.type.rawValue
            var annotationView: MKAnnotationView?

            if let dequeuedAnnotationView = mapView
                .dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            } else {
                let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = av
            }

            if let annotationView = annotationView {
                annotationView.canShowCallout = false

                if let mapPin = annotationView.annotation as? MapPinAnnotation {
                    annotationView.image = mapPin.imageView.image
                }
            }

            return annotationView
        } else {
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let mapPin = view.annotation as? MapPinAnnotation {
            mapPin.isSelected = true
            view.image = mapPin.imageView.image
            delegate?.locationTapped(type: mapPin.type)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let mapPin = view.annotation as? MapPinAnnotation {
            mapPin.isSelected = false
            view.image = mapPin.imageView.image
        }
    }
}
