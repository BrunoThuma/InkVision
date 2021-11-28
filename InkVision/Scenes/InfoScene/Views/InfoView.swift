//
//  InfoView.swift
//  InkVision
//
//  Created by Bruno Thuma on 25/11/21.
//

import UIKit

class InfoView: UIView {
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Ink What?"
        label.font = UIFont(name: "OCR-A BT", size: 52)
        
        return label
    }()
    
    lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.text = "We are creating open-air galleries through computer vision."
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        
        return button
    }()

    lazy var bigStarIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "InkVisionStar")

        return icon
    }()
    
    var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 370, height: 850))
    
    var startButton: ButtonFilled = .createButton(text: "Start right now!")
    
    var discoverFeatureView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        
        let info = InfoFeatureView(iconAssetName: "mapFeature",
                                      title: "DISCOVER",
                                      description: "Explore your city in our app to find amazing arts. Click on the pins on the map and see the shortest path to it.")
    
        container.addSubview(info)
        
        return container
    }()
    
    var createFeatureView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        
        let info = InfoFeatureView(iconAssetName: "createFeature",
                                      title: "CREATE",
                                      description: "Create your own artwork with the help of generative art to publish in the city. On the plus button you will find unusual ways to create your own art. See how to create it below!")
    
        container.addSubview(info)
        
        return container
    }()
    
    var shareFeatureView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        
        let info = InfoFeatureView(iconAssetName: "shareFeature",
                                      title: "SHARE",
                                      description: "Share with whoever you want! Post on your social media or just save it to your photo gallery to store with love.")
    
        container.addSubview(info)
        
        return container
    }()

    init() {
        super.init(frame: .zero)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 6.0]
        gradientLayer.frame = scrollView.bounds
        scrollView.layer.insertSublayer(gradientLayer, at: 0)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        setupHierarchy()
        setupScrollViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
        title.layoutIfNeeded()
        if title.bounds != .zero {
            let titleGradient = getGradientLayer(bounds: title.bounds)
            title.textColor = gradientColor(bounds: title.bounds, gradientLayer: titleGradient)
        }
    }
    
    func setupScrollViewHierarchy() {
        scrollView.addSubview(closeButton)
        scrollView.addSubview(bigStarIcon)
        scrollView.addSubview(title)
        scrollView.addSubview(descriptionText)
        scrollView.addSubview(discoverFeatureView)
        scrollView.addSubview(createFeatureView)
        scrollView.addSubview(shareFeatureView)
        scrollView.addSubview(startButton)
    }
    
    func setupHierarchy() {
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.leadingMargin.equalTo(30)
            make.topMargin.equalTo(30)
        }
        
        bigStarIcon.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.topMargin.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        descriptionText.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.topMargin.equalTo(270)
            make.centerX.equalToSuperview()
        }
        
        discoverFeatureView.snp.makeConstraints { make in
            make.topMargin.equalTo(340)
            make.leadingMargin.equalTo(40)
        }
        
        createFeatureView.snp.makeConstraints { make in
            make.topMargin.equalTo(480)
            make.leadingMargin.equalTo(40)
        }
        
        shareFeatureView.snp.makeConstraints { make in
            make.topMargin.equalTo(600)
            make.leadingMargin.equalTo(40)
        }

        startButton.snp.makeConstraints { make in
            make.topMargin.equalTo(750)
            make.centerX.equalToSuperview()
        }
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
