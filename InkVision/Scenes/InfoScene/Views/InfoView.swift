//
//  InfoView.swift
//  InkVision
//
//  Created by Bruno Thuma on 25/11/21.
//

import UIKit

class InfoView: UIView {

    var bigStarIcon: UIImageView = {
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 99)
        
        let icon = UIImageView(frame: .zero)
        icon.image = UIImage(systemName: "star.fill",
                             withConfiguration: iconConfig)
        icon.contentMode = .scaleAspectFit
        // FIXME: This should be gradient color
        icon.tintColor = .red
        return icon
    }()
    
    var scrollView: UIScrollView = UIScrollView(frame: .zero)

    init() {
        super.init(frame: .zero)
        
        // FIXME: remove colored background, was used only for testing
        backgroundColor = .gray
        
        let gradient = CAGradientLayer()

        gradient.frame = scrollView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.white.cgColor]

        scrollView.layer.insertSublayer(gradient, at: 0)
        
        setupHierarchy()
        setupScrollViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollViewHierarchy() {
        scrollView.addSubview(bigStarIcon)
    }
    
    func setupHierarchy() {
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
        
        bigStarIcon.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(73)
            make.centerX.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if bigStarIcon.bounds != .zero {
            let titleGradient = getGradientLayer(bounds: bigStarIcon.bounds)
            bigStarIcon.tintColor = gradientColor(bounds: bigStarIcon.bounds,
                                               gradientLayer: titleGradient)
        }
    }
}
