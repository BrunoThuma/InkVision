//
//  DrawView.swift
//  InkVision
//
//  Created by Bruno Thuma on 22/11/21.
//

import UIKit

class DrawView: UIView {
    
   // var pathToBeRandomized:[MyBezierPath] = []
    var showPath:[CGPoint] = []
    var shownPath = MyBezierPath()
    var bezierArray: [MyBezierPath] = []
    var bShowPath = true
    var bShowRandom = false
    var bClear = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 9
    
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        let saver = ImageSaver()
        saver.writeToPhotoAlbum(image: image)
        
        return image
    }
    
    override func draw( _ rect: CGRect) {
        self.backgroundColor = .clear
        //super.draw(rect)
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 250, y: 300))
//        path.addLine(to: CGPoint(x: 300, y: 400))
//        UIColor.green.setStroke()
//        path.lineWidth = 10
//        path.close()
    
        if bShowPath && showPath.count > 0{
            shownPath.contractionFactor = CGFloat(1)
            shownPath.move(to: showPath.first!)
            shownPath.addBezierThrough(points: showPath)
            
            UIColor.green.setStroke()
            shownPath.lineWidth = 10
            shownPath.stroke()
            showPath.removeAll()
            
            bShowPath = false
            print("BSHOWPATH")
        }
        
        if bShowRandom {
            bezierArray = ArtFromPath.drawArt(path: shownPath)
            print(shownPath.points.count)
            bShowRandom = false
            print("BSHOWRANDOM")
        }
        
        if bClear {
            //defer { setNeedsDisplay() }
            let context = UIGraphicsGetCurrentContext()
            context?.clear(bounds)
            //            context?.fill(bounds)
            for path in bezierArray{
                path.removeAllPoints()
            }
            shownPath.removeAllPoints()
            bClear = false
            print("BSHOWCLEAR")
        }
    }
}
