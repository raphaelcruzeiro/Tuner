//
//  CGPoint+Extensions.swift
//  Tuner
//
//  Created by Raphael Cruzeiro on 04/03/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {

    func distance(from point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }

}
