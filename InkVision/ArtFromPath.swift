//
//  ArtFromPath.swift
//  Generative
//
//  Created by Paulo Tadashi Tokikawa on 19/11/21.
//

import Foundation
import UIKit


final class ArtFromPath {
    static var iterations = 30
    static var rControl1: CGFloat = 100
    static var rControl2: CGFloat = 40
    static var rQuad: CGFloat = 20
    static var rPoint: CGFloat = 20
    static var bezierPath: [MyBezierPath] = []
    
    static let shared = ArtFromPath()
    
    static func drawArt (path: MyBezierPath) -> [MyBezierPath] {
        for _ in 0...iterations {
            bezierPath.append(drawGeneration(path: path))
        }
        return bezierPath
    }
    
    static func drawGeneration (path: MyBezierPath) -> MyBezierPath{
        
        let newPath = MyBezierPath()
        var lastCurve: CGPoint? = nil
        var lastPoint: CGPoint? = nil
        for bits in path.points {
            switch bits {
            case .move(let cGPoint):
                newPath.move(to: cGPoint)
                lastPoint = CGPoint(x: 195, y: 0)
            case .line(let cGPoint):
                print(cGPoint)
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                print(center, radius, startAngle, endAngle, clockwise)
            case .quadCurve(let endPoint, let controlPoint):
                newPath.addQuadCurve(to: endPoint, controlPoint: randomPointDistance(distance: rQuad, currentPoint: controlPoint))
            case .curve(let endPoint, let controlPoint1, let controlPoint2):
                let randomPoint = randomPointDistance(distance: rPoint, currentPoint: endPoint)
                if let lastCurve = lastCurve {
                    if let lastPoint = lastPoint {
                        newPath.addCurve(to: randomPoint, controlPoint1: pointThroughDistance(initial: lastCurve, final: lastPoint, distance: 70), controlPoint2: randomPointDistance(distance: rControl2, currentPoint: controlPoint2))
                    }
                    else {
                        print("no last point")
                        fatalError()
                    }
                } else {
                    newPath.addCurve(to: randomPoint, controlPoint1: randomPointDistance(distance: rControl2, currentPoint: controlPoint1), controlPoint2: randomPointDistance(distance: rControl2, currentPoint: controlPoint2))
                }
            }
            switch newPath.points.last {
            case .move(_):
                break
            case .curve(let endPoint, _, let controlPoint2):
                lastPoint = endPoint
                lastCurve = controlPoint2
            case .quadCurve(let endPoint, let controlPoint):
                lastPoint = endPoint
                lastCurve = controlPoint
            default:
                print("want curves")
            }
        }
        UIColor.randomA(alpha: 1).setStroke()
        newPath.lineWidth = 1
        newPath.stroke()
        newPath.close()
        
        return newPath
    }
    
    static func pointThroughDistance(initial: CGPoint, final: CGPoint, distance: CGFloat) -> CGPoint {
        let randomized = CGFloat.random(in: 50 ... distance+50)
        let m = abs((initial.y - final.y) / (initial.x - final.x))
        //________________________ CRIAR EXCESSÃO LINHA RETA ________________________________
        let a = m * m + 1
        let b = (-2 * final.x) + (-2 * final.x * m * m)
        let c = (final.x * final.x) + (m * final.x) * (m * final.x) - randomized * randomized
        var x: CGFloat
        let delta:CGFloat = b * b - 4 * a * c
        if delta < 0 {
            x = final.x
            print ("no possible straights 🏳️‍🌈")
            fatalError()
        }
        else if delta > 0 {
            let xa = (-b + sqrt(delta)) / (2 * a)
            let xb = (-b - sqrt(delta)) / (2 * a)
            if final.x > initial.x {
                x = max(xa, xb)
                if x < final.x {
                    print("x smaller than final")
                    fatalError()
                }
            }
            else if final.x < initial.x {
                x = min(xa, xb)
                if x > final.x {
                    print("x greater than final")
                    fatalError()
                }
            }
            else {
                print("x equal to final")
                fatalError()
            }
        }
        else {
            x = -b / 2 * a
        }
        let y = m * (x - final.x)  + final.y
//        print(CGPoint(x: x, y: y))
        return CGPoint(x: x, y: y)
    }
    
    static func randomPointDistance(distance: CGFloat, currentPoint: CGPoint) -> CGPoint{
        let x = CGFloat.random(in: -distance...distance) + currentPoint.x
        let y = CGFloat.random(in: -distance...distance) + currentPoint.y
        return CGPoint(x: x, y: y)
    }
}

extension UIColor {
    static func randomA(alpha: Double) -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: alpha
        )
    }
}
