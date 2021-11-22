//
//  ViewController.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 29/10/21.
//

import UIKit

class ViewController: UIViewController {

    private lazy var createArtButton: ButtonFilled = .createButton(text: "teste", buttonImage: nil)
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
        
        createArtButton.addTarget(self, action: #selector(createArtButtonTapped), for: .touchUpInside)
    }
    
    func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(createArtButton)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        createArtButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(label.snp_bottomMargin).offset(30)
        }
    }
    
    func presentBodyTrackingVC() {
        let bodyTrackingVC = MotionDetectionViewController()
        navigationController?.pushViewController(bodyTrackingVC, animated: true)
    }
    
    @objc func createArtButtonTapped() {
        presentBodyTrackingVC()
    }
}
