//
//  InfoFeatureView.swift
//  InkVision
//
//  Created by João Pedro Picolo on 27/11/21.
//

import UIKit

class InfoFeatureView: UIView {
    var hStack: UIStackView = {
        let hStack = UIStackView(frame: .zero)
        hStack.axis = .horizontal
        return hStack
    }()
    
    var vStack: UIStackView = {
        let vStack = UIStackView(frame: .zero)
        vStack.axis = .vertical
        return vStack
    }()
    
    private var icon: UIImageView
    private var featureTitle: UILabel
    private var featureDescription: UILabel
    
    init(iconAssetName: String, title: String, description: String) {
        icon = UIImageView(frame: .zero)
        icon.image = UIImage(named: iconAssetName)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        featureTitle = UILabel(frame: .zero)
        featureTitle.font = UIFont(name: "OCR-A BT", size: 16)
        featureTitle.text = title
        featureTitle.textAlignment = .center
        
        featureDescription = UILabel(frame: .zero)
        featureDescription.font = UIFont.systemFont(ofSize: 10, weight: .light)
        featureDescription.text = description
        featureDescription.numberOfLines = 0
        featureDescription.lineBreakMode = .byWordWrapping
        featureDescription.textAlignment = .left
        
        super.init(frame: .zero)
        
        vStack.addArrangedSubview(icon)
        vStack.addArrangedSubview(featureTitle)
        
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(featureDescription)
        hStack.spacing = 5

        
        hStack.layer.cornerRadius = 10
        hStack.layer.masksToBounds = true
        hStack.backgroundColor = .black
        
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        addSubview(hStack)
    }

    func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.width.equalTo(53)
            make.height.equalTo(57)
        }
        
        hStack.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        vStack.snp.makeConstraints { make in
            make.width.equalTo(100)
            
            make.leadingMargin.equalTo(20)
            make.topMargin.equalTo(20)
            make.bottomMargin.equalTo(-14)
        }
        
        featureDescription.snp.makeConstraints { make in
            make.width.equalTo(170)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hStack.layoutIfNeeded()
        vStack.layoutIfNeeded()
        
        featureTitle.layoutIfNeeded()
        
        if featureTitle.bounds != .zero {
            let titleGradient = getGradientLayer(bounds: featureTitle.bounds)
            featureTitle.textColor = gradientColor(bounds: featureTitle.bounds,
                                               gradientLayer: titleGradient)
        }
    }
}
