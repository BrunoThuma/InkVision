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
    
    private var sub: UIView = UIView(frame:
                                        CGRect(x:0,
                                               y:0,
                                               width: 201,
                                               height: 37
                                              ))
    private var tipTitle: UILabel
    private var icon: UIImageView
    private var tipDescription: UILabel
    
    init(sfIconName: String, title: String, description: String) {
        
        print("tip is alive")
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 46)
        icon = UIImageView(frame: .zero)
        icon.image = UIImage(systemName: sfIconName, withConfiguration: iconConfig)
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
        
//        sub.frame = tipTitle.bounds
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPink.cgColor,
                           UIColor.purple.cgColor,
                           UIColor.cyan.cgColor]

        gradient.startPoint = CGPoint(x: 0.3, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.6, y: 0.5)
        
        gradient.frame = sub.bounds
        print(tipTitle.bounds)
        print(sub.bounds)
        sub.layer.addSublayer(gradient)
        
        sub.addSubview(tipTitle)
        sub.mask = tipTitle
        
        vStack.distribution = .equalSpacing
        vStack.addArrangedSubview(sub)
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
//        addSubview(sub)
        addSubview(hStack)
    }

    func setupConstraints() {
        hStack.snp.makeConstraints { make in
            make.height.equalTo(85)
        }
//        sub.snp.makeConstraints { make in
//            make.height.equalTo(85)
//        }
    }
}
