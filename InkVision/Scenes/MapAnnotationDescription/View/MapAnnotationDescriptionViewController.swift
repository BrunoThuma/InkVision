//
//  MapAnnotationDescriptionViewController.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//

import UIKit

class MapAnnotationDescriptionViewController: UIViewController {

    override func loadView() {
        view = MapAnnotationDescriptionView(name: "Yasmin's art",
                                            distance: "600",
                                            address:
"""
Rua Oliveira Viana, 070
Hauer
Curitiba - PR
81630-070
Brasil
""",
                                            travelMinutes: "4")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
