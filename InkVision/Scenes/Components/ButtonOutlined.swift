//
//  ButtonOutlined.swift
//  InkVision
//
//  Created by João Pedro Picolo on 17/11/21.
//

import UIKit
import SnapKit

class ButtonOutlined: UIButton {
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
  }

  // Compilador briga com a gente se não implementarmos isso
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func createButton(text: String) -> ButtonOutlined {
    let button = ButtonOutlined()
    
   
    button.setTitle(text, for: .normal)
    button.setTitleColor(UIColor(named: "pink"), for: .normal)

    button.titleLabel?.lineBreakMode = .byWordWrapping
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = .systemFont(ofSize: 13)
    
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 8
    button.layer.borderColor = UIColor(named: "pink")?.cgColor
    
    button.snp.makeConstraints { make in
      make.height.equalTo(54)
      make.width.equalTo(270)
    }
    
    return button
  }
}
