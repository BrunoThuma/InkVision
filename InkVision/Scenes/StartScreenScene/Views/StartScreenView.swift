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
        let view = StartScreenTipView(sfIconName: "map.circle",
                                      title: "DISCOVER",
                                      description: "Explore your city in our app to\nfind amazing arts.")
        return view
    }()
    
    var createTipView: StartScreenTipView = {
        let view = StartScreenTipView(sfIconName: "plus.circle",
                                      title: "CREATE",
                                      description: "Create your own artwork with\nthe help of generative art to\npublish in the city.")
        return view
    }()
    
    var startButton: ButtonFilled = .createButton(text: "Start!")
    
    init() {
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
        addSubview(discoverTipView)
        addSubview(createTipView)
        addSubview(startButton)
    }

    private func setupConstraints() {
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-72)
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
        
        backgroundImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    func addTargetToStartButton(_ target: Any?, action: Selector) {
        startButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
