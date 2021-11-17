//
//  ViewController.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 29/10/21.
//

import UIKit

class ViewController: UIViewController {

    private lazy var createArtButton: UIButton = .init()
    private lazy var label: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        // Do any additional setup after loading the view.
        
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    func setupViews() {
        label.textColor = .black
        label.text = "teste"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        createArtButton.setTitle("Create Art", for: .normal)
        createArtButton.setTitleColor(.black, for: .normal)
        createArtButton.translatesAutoresizingMaskIntoConstraints = false
        createArtButton.addTarget(self, action: #selector(createArtButton), for: .touchUpInside)
    }
    
    func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(createArtButton)
    }
    
    func setupConstraints() {
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            createArtButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createArtButton.topAnchor.constraint(equalTo: label.bottomAnchor,
                                                 constant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func presentBodyTrackingVC() {
        let bodyTrackingVC = MotionDetectionViewController()
        navigationController?.pushViewController(bodyTrackingVC, animated: true)
    }
    
    @objc func createArtButtonTapped() {
        presentBodyTrackingVC()
    }
}
