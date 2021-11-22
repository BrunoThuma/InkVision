//
//  ButtonFilled.swift
//  InkVision
//
//  Created by João Pedro Picolo on 18/11/21.
//
import UIKit
import SnapKit

class ButtonFilled: UIButton {
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
  }

  // Compilador briga com a gente se não implementarmos isso
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func createButton(text: String, buttonImage: String? = nil) -> ButtonFilled {
    let button = ButtonFilled()
   
    button.setTitle(text, for: .normal)
    button.setTitleColor(.white, for: .normal)

    button.titleLabel?.lineBreakMode = .byWordWrapping
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    
    if buttonImage != nil {
      button.tintColor = UIColor.white
      button.setImage(UIImage(systemName: buttonImage!), for: .normal)
      
      button.imageView!.snp.makeConstraints { make in
        make.trailing.equalTo(-15)
        make.centerY.equalToSuperview()
      }
    }
    
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 8
    button.layer.borderColor = UIColor(named: "pink")?.cgColor

    button.backgroundColor = UIColor(named: "pink")
    
    button.snp.makeConstraints { make in
      make.height.equalTo(44)
      make.width.equalTo(270)
    }
    
    return button
  }
}
