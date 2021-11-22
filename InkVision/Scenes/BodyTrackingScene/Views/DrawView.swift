//
//  DrawView.swift
//  InkVision
//
//  Created by Bruno Thuma on 22/11/21.
//

import UIKit

class DrawView: UIView {
    
    var path: MyBezierPath
    
    init(frame: CGRect, path: MyBezierPath) {
        self.path = path
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw( _ rect: CGRect) {
        ArtFromPath.drawArt(path: path)
    }
}
