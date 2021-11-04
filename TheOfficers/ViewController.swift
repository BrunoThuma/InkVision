//
//  ViewController.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 29/10/21.
//

import UIKit

class ViewController: UIViewController {

    private lazy var label: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        // Do any additional setup after loading the view.
        
        label.textColor = .black
        label.text = "teste"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
