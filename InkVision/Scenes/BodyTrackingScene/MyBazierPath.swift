import UIKit

enum BezierBit {
    case move(CGPoint)
    case line(CGPoint)
    case arc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
    case quadCurve(endPoint: CGPoint, controlPoint: CGPoint)
    case curve(endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)
}

final class MyBezierPath: UIBezierPath {
    var points: [BezierBit] = []

    override func move(to point: CGPoint) {
        points.append(.move(point))
        super.move(to: point)
    }

    override func addLine(to point: CGPoint) {
        points.append(.line(point))
        super.addLine(to: point)
    }

    override func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        self.points.append(.arc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise))
        super.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    override func addCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.points.append(.curve(endPoint: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2))
        super.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    override func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint) {
        self.points.append(.quadCurve(endPoint: endPoint, controlPoint: controlPoint))
        super.addQuadCurve(to: endPoint, controlPoint: controlPoint)
    }
}
