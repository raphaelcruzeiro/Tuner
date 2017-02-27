//
//  VUMeterView.swift
//  Tuner
//
//  Created by Raphael Cruzeiro on 25/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import UIKit

class VUMeterView: UIView {

    var value: Double = 0 {
        didSet {
            set(value: value)
        }
    }

    // swiftlint:disable:next variable_name
    private let θ = CGFloat.pi / 4

    private var backgroundLayer: CAShapeLayer?
    private var needleLayer: CAShapeLayer?
    private var dialCenter: CGPoint!
    private var needleLength: CGFloat!
    
    // expose these to testing
    var topLeft: CGPoint!
    var topRight: CGPoint!
    var bottomLeft: CGPoint!
    var bottomRight: CGPoint!
    var pointingTo: CGFloat!
    

    init() {
        super.init(frame: .zero)
        //clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLayer?.removeFromSuperlayer()

        let w = frame.width - 16
        let r = w * sin(θ)
        needleLength = r - 5

        dialCenter = CGPoint(x: center.x, y: r)
        let start: CGFloat = 3 * θ
        let end: CGFloat = θ

        let upperArcRadius = r
        let bottomArcRadius = r * 0.4

        topLeft = pointOnCircle(center: dialCenter, radius: upperArcRadius, angle: start)
        topRight = pointOnCircle(center: dialCenter, radius: upperArcRadius, angle: end)
        bottomLeft = pointOnCircle(center: dialCenter, radius: bottomArcRadius, angle: start)
        bottomRight = pointOnCircle(center: dialCenter, radius: bottomArcRadius, angle: end)

        let cgStart =  5 * θ
        let cgEnd = 7 * θ

        let upperArc = drawArc(with: dialCenter, radius: upperArcRadius, start: cgStart, end: cgEnd)
        let bottomArc = drawArc(with: dialCenter, radius:  bottomArcRadius, start: cgStart, end: cgEnd)
        let leftLine = drawLine(from: topLeft, to: bottomLeft)
        let rightLine = drawLine(from: topRight, to: bottomRight)

        layer.addSublayer(upperArc)
        layer.addSublayer(bottomArc)
        layer.addSublayer(leftLine)
        layer.addSublayer(rightLine)

        set(value: value)
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y - radius * sin(angle)
        return CGPoint(x: x, y: y)
    }

    // swiftlint:disable:next variable_name
    private func drawLine(from: CGPoint, to: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 1

        path.move(to: from)
        path.addLine(to: to)

        shape.path = path.cgPath
        return shape
    }

    private func drawArc(with center: CGPoint,
                         radius: CGFloat,
                         start: CGFloat,
                         end: CGFloat,
                         fillColor: UIColor = .clear) -> CAShapeLayer {
        let path = UIBezierPath()
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = fillColor.cgColor
        shape.lineWidth = 1

        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: true
        )
        shape.path = path.cgPath

        return shape
    }

    private func set(value: Double) {
        let delta = CGFloat(value) * CGFloat.pi / 4
        pointingTo =  CGFloat.pi / 2 - delta
        let path = UIBezierPath()
        path.move(to: dialCenter)
        path.addLine(to: pointOnCircle(center: dialCenter, radius: needleLength, angle: pointingTo))

        guard let needleLayer = needleLayer else {
            self.needleLayer = CAShapeLayer()
            self.needleLayer!.strokeColor = UIColor.white.cgColor
            self.needleLayer!.lineWidth = 2
            self.needleLayer!.path = path.cgPath
            layer.addSublayer(self.needleLayer!)
            return
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = path.cgPath
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false

        needleLayer.add(animation, forKey: animation.keyPath)
    }

}
