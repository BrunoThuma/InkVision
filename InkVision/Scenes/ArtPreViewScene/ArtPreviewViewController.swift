//
//  ArtPreviewViewController.swift
//  InkVision
//
//  Created by João Pedro Picolo on 28/11/21.
//

import UIKit

class ArtPreviewViewController: UIViewController {
    var artView: UIImageView = UIImageView()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(named: "pink")
        
        return button
    }()
    
    var continueButton: ButtonFilled = .createButton(text: "Continue", buttonImage: "arrow.forward")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupConstraints()
        initGestureRecognizers()
    }
    
    func setupHierarchy() {
        view.backgroundColor = UIColor(named: "backgroundGray")
        
        artView.image = UIImage(named: "grafite")
        view.addSubview(artView)
        view.addSubview(downloadButton)
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
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(730)
            make.leading.equalTo(30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(730)
            make.centerX.equalToSuperview().offset(30)
        }
    }
    
    func initGestureRecognizers() {
        downloadButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(nextScene), for: .touchUpInside)
    }
    
    @objc
    func savePhoto() {
        guard let image = artView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let alert = UIAlertController(title: "Success", message: "Art was successfully saved in your gallery", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
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
