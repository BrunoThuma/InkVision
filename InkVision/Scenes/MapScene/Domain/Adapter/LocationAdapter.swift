//
//  LocationAdapter.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//  Credits to Vinicius Couto

import CoreLocation

final class LocationAdapter: NSObject, CLLocationManagerDelegate {
    // MARK: - Private variables

    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?

    // MARK: - Public variables

    weak var delegate: LocationAdapterDelegate?

    // MARK: - Initialization

    override init() {
        super.init()

        locationManager.delegate = self

        bootLocationService()
    }

    // MARK: - Private methods

    private func bootLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Public methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            delegate?.didLocateUser()
        }
    }
}
