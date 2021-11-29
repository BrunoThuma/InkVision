//
//  ArtPreviewViewController.swift
//  InkVision
//
//  Created by João Pedro Picolo on 28/11/21.
//

import UIKit

class ArtPreviewViewController: UIViewController {
    var artView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var continueButton: ButtonFilled = .createButton(text: "Find a wall", buttonImage: "arrow.forward")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupConstraints()
        initGestureRecognizers()
    }
    
    func setupHierarchy() {
        view.backgroundColor = UIColor(named: "backgroundGray")
        self.navigationController?.isNavigationBarHidden = true

        view.addSubview(artView)
        view.addSubview(continueButton)
    }
    
    func setupConstraints() {
        artView.layer.cornerRadius = 30
        artView.layer.borderWidth = 0.1
        artView.layer.masksToBounds = true
        artView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-130)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(730)
            make.centerX.equalToSuperview()
        }
    }
    
    func initGestureRecognizers() {
        continueButton.addTarget(self, action: #selector(nextScene), for: .touchUpInside)
    }

    @objc
    func nextScene() {
        let newScene = WallDetectionViewController()
        artView.layer.borderWidth = 0
        artView.layer.cornerRadius = 0
        artView.layer.masksToBounds = false
        newScene.artView = artView
        self.navigationController?.pushViewController(newScene, animated: true)
    }
}
