//
//  StartScreenView.swift
//  InkVision
//
//  Created by Bruno Thuma on 24/11/21.
//

import UIKit

class StartScreenView: UIView {
    
    var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: .zero)
        backgroundImage.image = UIImage(named: "background2")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    var discoverTipView: StartScreenTipView = {
        let view = StartScreenTipView(iconAssetName: "InkVisionIconMap",
                                      title: "DISCOVER",
                                      description: "Explore your city in our app to\nfind amazing arts.")
        return view
    }()
    
    var createTipView: StartScreenTipView = {
        let view = StartScreenTipView(iconAssetName: "InkVisionIconPlusCircle",
                                      title: "CREATE",
                                      description: "Create your own artwork with\nthe help of generative art to\npublish in the city.")
        return view
    }()
    
    var startButton: ButtonFilled = .createButton(text: "Start!")
    
    var darkView: UIView
    
    init() {
        darkView = UIView(frame: .zero)
        darkView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        super.init(frame: .zero)
        
        insetsLayoutMarginsFromSafeArea = false
        
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        insertSubview(backgroundImage, at: 0)
        addSubview(darkView)
        addSubview(discoverTipView)
        addSubview(createTipView)
        addSubview(startButton)
    }

    private func setupConstraints() {
        
        backgroundImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        darkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        discoverTipView.snp.makeConstraints { make in
            make.leadingMargin.equalToSuperview().offset(47)
            make.trailingMargin.equalToSuperview().offset(-68)
            make.centerY.equalToSuperview().offset(-100)
        }
        
        createTipView.snp.makeConstraints { make in
            make.leadingMargin.equalToSuperview().offset(47)
            make.trailingMargin.equalToSuperview().offset(-68)
            make.centerY.equalToSuperview().offset(10)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-72)
        }
    }
    
    func addTargetToStartButton(_ target: Any?, action: Selector) {
        startButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
