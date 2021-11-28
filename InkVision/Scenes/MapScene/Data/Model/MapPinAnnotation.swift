//
//  MapPinAnnotation.swift
//  InkVision
//
//  Created by Bruno Thuma on 27/11/21.
//  Credits to Vinicius Couto

import MapKit

class MapPinAnnotation: NSObject, MKAnnotation {
    // MARK: - Public attributes

    let id: UUID = .init()
    // TODO: Fix color
    let unselectedColor: UIColor = UIColor(named: "InkVisionMapPinBlue")!

    let coordinate: CLLocationCoordinate2D
    let type: MapPinType
    let title: String?

    var isSelected: Bool = false {
        didSet {
            if isSelected {
                imageView.image = imageView.image?.imageWithColor(color: selectedColor)
            } else {
                imageView.image = imageView.image?.imageWithColor(color: unselectedColor)
            }
            imageView.layoutIfNeeded()
        }
    }

    // MARK: - Lazy variables

    // TODO: Fix icon, system name and UIImage call
    lazy var imageView: UIImageView = {
        let asset = (self.type == .art) ? "questionmark.circle.fill" :  "questionmark.circle"

        return UIImageView(image: UIImage(systemName: asset)!.imageWithColor(color: unselectedColor))
    }()

    // TODO: Fix color
    lazy var selectedColor: UIColor = {
        (type == .art) ? UIColor.green : UIColor.red
    }()

    // MARK: - Initialization

    init(title: String, coordinate: CLLocationCoordinate2D, type: MapPinType) {
        self.coordinate = coordinate
        self.title = title
        self.type = type
    }
}
