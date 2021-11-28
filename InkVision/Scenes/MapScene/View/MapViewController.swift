//
//  MapViewController.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//

import MapKit
import SnapKit
import UIKit

final class MapViewController: UIViewController {
    // MARK: - Private variables

    private let locationAdapter: LocationAdapter = .init()
    private let mapAdapter: MapAdapter = .init()

    private lazy var mapView: MKMapView = .init()
    private lazy var infoButton: MapButtonView = .init(iconName: "questionmark",
                                                      action: presentAddMenuModal)
    private lazy var locationButton: MapButtonView = .init(iconName: "location",
                                                           action: willLocateUser)
    private lazy var createButton: MapButtonView = .init(iconName: "plus.circle",
                                                           action: willLocateUser)
    private weak var userLocationDelegate: UserLocationDelegate?

    // MARK: - Overridden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupHierarchy()
        setupDelegates()
        setupConstraints()

        // TODO: this ugly. make pretty.
        #if DEBUG
            let repository = MapPinAnnotationRepository()
            let pins = repository.pins()
            mapView.addAnnotations(pins)
        #endif
    }

    // MARK: - Private methods

    private func setupViews() {
        definesPresentationContext = true

        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = false
        mapView.delegate = mapAdapter
    }

    private func setupDelegates() {
        locationAdapter.delegate = self
        mapAdapter.delegate = self
    }

    private func setupHierarchy() {
        view.addSubview(mapView)
        view.addSubview(infoButton)
        view.addSubview(locationButton)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        infoButton.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
                .offset(LayoutMetrics.addButtonTopOffset)
            make.trailingMargin.equalToSuperview()
                .offset(LayoutMetrics.trailingOffset)
        }

        locationButton.snp.makeConstraints { make in
            make.top.equalTo(infoButton.snp.bottom)
                .offset(LayoutMetrics.buttonDistance)
            make.trailingMargin.equalToSuperview()
                .offset(LayoutMetrics.trailingOffset)
        }
    }

    // MARK: - Present child modals methods

    private func presentAddMenuModal() {
        let menuVC = InfoViewController()
//        menuVC.modalDelegate = self
        present(menuVC, animated: true)
    }

//    private func presentAddLocationModal(_ selectedLocationType: MapPinType) {
//        let locationVC: AddLocationFormsController = .init(locationType: selectedLocationType)
//
//        if let lastKnownLocation = getUserLocation() {
//            locationVC.setLastKnownLocation(lastKnownLocation)
//        } else {
//            // FIXME: avoid this
//            fatalError("could not update users last known location")
//        }
//
//        modalPresentationStyle = .overCurrentContext
//        present(locationVC, animated: true)
//    }
    
    private func presentAddLocationModal(_ selectedLocationType: MapPinType) {
        let menuVC = InfoViewController()
//        menuVC.modalDelegate = self
        present(menuVC, animated: true)
    }

    private func presentLocationOptionModal(of type: MapPinType) {
        let menuVC = InfoViewController()
        modalPresentationStyle = .overCurrentContext
        present(menuVC, animated: true, completion: nil)
    }

    // MARK: - Layout Metrics

    private enum LayoutMetrics {
        static let centeringRegionRadius: CLLocationDistance = 1000
        static let resultsViewAnimationDuration: TimeInterval = 0.2
        static let searchBarClosedBottomOffset: CGFloat = -30
        static let searchBarOpenBottomOffset: CGFloat = 30
        static let searchBarLeadingOffset: CGFloat = 5
        static let searchBarInteractionAnimationDuration: TimeInterval = 0.2
        static let trailingOffset: CGFloat = -5
        static let addButtonTopOffset: CGFloat = 15
        static let buttonDistance: CGFloat = 5
    }
}

extension MapViewController: LocationAdapterDelegate, MapAdapterDelegate {
    func didLocateUser() { mapView.showsUserLocation = true }

    func willLocateUser() {
        guard let location = locationAdapter.currentLocation else { return }

        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             latitudinalMeters: LayoutMetrics.centeringRegionRadius,
                                             longitudinalMeters: LayoutMetrics.centeringRegionRadius), animated: true)
    }

    func getUserLocation() -> CLLocation? {
        guard let location = locationAdapter.currentLocation else { return nil }

        return location
    }

    func locationTapped(type: MapPinType) {
        presentLocationOptionModal(of: type)
    }
}
