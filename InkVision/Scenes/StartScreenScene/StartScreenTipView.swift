//
//  StartScreenTipsView.swift
//  InkVision
//
//  Created by Bruno Thuma on 24/11/21.
//

import UIKit

class StartScreenTipView: UIView {
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
    
    private var tipTitle: UILabel
    private var icon: UIImageView
    private var tipDescription: UILabel
    
    init(iconAssetName: String, title: String, description: String) {
        
//        let iconConfig = UIImage.SymbolConfiguration(pointSize: 46)
        icon = UIImageView(frame: .zero)
        icon.image = UIImage(named: iconAssetName)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        tipTitle = UILabel(frame: .zero)
        tipTitle.font = UIFont(name: "OCR-A BT", size: 40)
        tipTitle.text = title
        tipTitle.textAlignment = .left
        tipTitle.translatesAutoresizingMaskIntoConstraints = false
        
        tipDescription = UILabel(frame: .zero)
        // FIXME: The font used here is not the correct one
        tipDescription.font = UIFont.systemFont(ofSize: 14)
        tipDescription.text = description
        tipDescription.numberOfLines = 0
        tipDescription.lineBreakMode = .byWordWrapping
        tipDescription.textAlignment = .left
        tipDescription.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        
        vStack.distribution = .equalSpacing
        vStack.addArrangedSubview(tipTitle)
        vStack.addArrangedSubview(tipDescription)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.distribution = .equalSpacing
        hStack.addArrangedSubview(icon)
        hStack.addArrangedSubview(vStack)
        hStack.spacing = 14
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
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
            make.height.equalTo(85)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        hStack.layoutIfNeeded()
        vStack.layoutIfNeeded()
        
        tipTitle.layoutIfNeeded()
        
        if tipTitle.bounds != .zero {
            let titleGradient = getGradientLayer(bounds: tipTitle.bounds)
            tipTitle.textColor = gradientColor(bounds: tipTitle.bounds,
                                               gradientLayer: titleGradient)
        }
    }
}
