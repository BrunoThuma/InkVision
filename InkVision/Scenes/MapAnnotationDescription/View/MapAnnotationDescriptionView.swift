//
//  MapAnnotationDescriptionView.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//

import UIKit

class MapAnnotationDescriptionView: UIView {
    
    private lazy var nameLabel: UILabel = .init(frame: .zero)
    private lazy var distanceLabel: UILabel = .init(frame: .zero)
    private lazy var travelButton: ButtonFilled = .createButton(text: "")
    private lazy var addressTitleLabel: UILabel = .init(frame: .zero)
    private lazy var addressDescriptionLabel: UILabel = .init(frame: .zero)
    
    init(name: String, distance: String, address: String, travelMinutes: String) {
        
        super.init(frame: .zero)
        
        backgroundColor = .systemGray5
        
        nameLabel.font = UIFont.systemFont(ofSize: 35)
        nameLabel.textColor = .white
        nameLabel.text = name
        
        distanceLabel.font = UIFont.systemFont(ofSize: 20)
        distanceLabel.textColor = .systemGray
        distanceLabel.text = "Distancia: \(distance) m"
        
        travelButton.setTitle("\(travelMinutes) minutes", for: .normal)
        
        addressTitleLabel.font = UIFont.systemFont(ofSize: 20)
        addressTitleLabel.textColor = .systemGray
        addressTitleLabel.text = "Endereço"
        
        addressDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        addressDescriptionLabel.numberOfLines = 0
        addressDescriptionLabel.textColor = .white
        addressDescriptionLabel.text = address
        
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(nameLabel)
        addSubview(distanceLabel)
        addSubview(travelButton)
        addSubview(addressTitleLabel)
        addSubview(addressDescriptionLabel)
    }
    
    private func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leadingMargin.equalToSuperview().offset(35)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(5)
            make.leadingMargin.equalToSuperview().offset(35)
        }
        
        travelButton.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
        }
        
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(travelButton.snp_bottomMargin).offset(30)
            make.leadingMargin.equalToSuperview().offset(41)
        }
        
        addressDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp_bottomMargin).offset(8)
            make.leadingMargin.equalToSuperview().offset(41)
        }
    }
}
