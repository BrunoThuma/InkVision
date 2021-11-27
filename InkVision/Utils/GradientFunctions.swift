//
//  GradientFunctions.swift
//  InkVision
//
//  Created by Bruno Thuma on 26/11/21.
//

import UIKit


func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    // Order of gradient colors
    gradient.colors = [UIColor(named: "InkVisionGradientPink")!.cgColor,
                       UIColor(named: "InkVisionGradientPurple")!.cgColor,
                       UIColor(named: "InkVisionGradientBlue")!.cgColor]
    // Start and end points
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    return gradient
}

func gradientColor(bounds: CGRect,
                   gradientLayer :CAGradientLayer) -> UIColor? {
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    
    // Create UIImage by rendering gradient layer.
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    // Get gradient UIcolor from gradient UIImage
    return UIColor(patternImage: image!)
}
