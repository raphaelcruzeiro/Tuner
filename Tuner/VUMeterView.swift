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

    var backgroundLayer: CAShapeLayer?

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

        let θ = CGFloat.pi / 4
        let w = frame.width - 16
        let r = w * sin(θ)

        let center = CGPoint(x: self.center.x, y: r)
        let start: CGFloat = 3 * θ
        let end: CGFloat = θ

        let upperArcRadius = r
        let bottomArcRadius = r * 0.4

        let topLeft = pointOnCircle(center: center, radius: upperArcRadius, angle: start)
        let topRight = pointOnCircle(center: center, radius: upperArcRadius, angle: end)
        let bottomLeft = pointOnCircle(center: center, radius: bottomArcRadius, angle: start)
        let bottomRight = pointOnCircle(center: center, radius: bottomArcRadius, angle: end)

        let cgStart =  5 * θ
        let cgEnd = 7 * θ

        let upperArc = drawArc(with: center, radius: upperArcRadius, start: cgStart, end: cgEnd)
        let bottomArc = drawArc(with: center, radius:  bottomArcRadius, start: cgStart, end: cgEnd)
        let leftLine = drawLine(from: topLeft, to: bottomLeft)
        let rightLine = drawLine(from: topRight, to: bottomRight)

        layer.addSublayer(upperArc)
        layer.addSublayer(bottomArc)
        layer.addSublayer(leftLine)
        layer.addSublayer(rightLine)
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

}
