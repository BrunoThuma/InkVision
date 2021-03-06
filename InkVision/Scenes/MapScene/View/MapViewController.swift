//
//  MapViewController.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//  Credits to Vinicius Couto

import MapKit
import SnapKit
import UIKit

final class MapViewController: UIViewController {
    // MARK: - Private variables

    private let locationAdapter: LocationAdapter = .init()
    private let mapAdapter: MapAdapter = .init()

    private lazy var mapView: MKMapView = .init()
    private lazy var infoButton: MapButtonView = .init(isSmallButton: true,
                                                       iconName: "questionmark",
                                                       action: presentAddMenuModal)
    private lazy var locationButton: MapButtonView = .init(isSmallButton: true,
                                                           iconName: "location",
                                                           action: willLocateUser)
    private lazy var createButton: MapButtonView = .init(isSmallButton: false,
                                                         iconName: "plus.circle",
                                                         action: presentCreateArtModal)
    private weak var userLocationDelegate: UserLocationDelegate?

    // MARK: - Overridden methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupHierarchy()
        setupDelegates()
        setupConstraints()

        #if DEBUG
            let repository = MapPinAnnotationRepository()
            let pins = repository.pins()
            mapView.addAnnotations(pins)
        #endif
    }
    
    // MARK: - Public methods
    
    #if DEBUG
        func addBruninsHomeToMap() {
            mapView.addAnnotation(MapPinAnnotation.fixtureArt4())
        }
    #endif
    
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
        view.addSubview(createButton)
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
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(LayoutMetrics.createButtonBottomOffset)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Present child modals methods

    private func presentAddMenuModal() {
        let menuVC = InfoViewController()
        present(menuVC, animated: true)
    }
    
    private func presentCreateArtModal() {
        let artVC = MotionDetectionViewController()
        artVC.delegate = self
        present(artVC, animated: true)
    }
    
    private func presentAddLocationModal(_ selectedLocationType: MapPinType) {
        let menuVC = InfoViewController()
//        menuVC.modalDelegate = self
        present(menuVC, animated: true)
    }

    private func presentLocationOptionModal(of type: MapPinType) {
        let menuVC = MapAnnotationDescriptionViewController()
        if let presentationController = menuVC.presentationController as? UISheetPresentationController {
            
            presentationController.detents = [.medium()]
        }
                
                self.present(menuVC, animated: true)
        
//        modalPresentationStyle = .overCurrentContext
//        present(menuVC, animated: true, completion: nil)
        addBruninsHomeToMap()
    }

    // MARK: - Layout Metrics

    private enum LayoutMetrics {
        static let centeringRegionRadius: CLLocationDistance = 1000
        static let resultsViewAnimationDuration: TimeInterval = 0.2
        static let trailingOffset: CGFloat = -5
        static let addButtonTopOffset: CGFloat = 15
        static let buttonDistance: CGFloat = 10
        static let createButtonBottomOffset = -60
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

protocol MapViewControllerDelegate: AnyObject {
    func presentArtPreview(image: UIImage)
}

extension MapViewController: MapViewControllerDelegate {
    func presentArtPreview(image: UIImage) {
        let newScene = ArtPreviewViewController()
        newScene.artImage = image
        self.navigationController?.pushViewController(newScene, animated: true)
    }
}

    
