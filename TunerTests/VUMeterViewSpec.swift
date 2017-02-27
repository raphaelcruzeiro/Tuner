//
//  VUMeterViewSpec.swift
//  Tuner
//
//  Created by Raphael Cruzeiro on 27/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Tuner

class VUMeterViewSpec: QuickSpec {
    
    override func spec() {

        var sut: VUMeterView!
        var superview: UIView!
        
        beforeEach {
            superview = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
            sut = VUMeterView()
            sut.frame = CGRect(x: 0, y: 100, width: 800, height: 260)
            superview.addSubview(sut)
            
            superview.setNeedsLayout()
            superview.layoutIfNeeded()
        }
        
        it("should correctly initialize the upper arc") {
            expect(sut.topLeft.x).to(beCloseTo(8, within: 0.01))
            expect(sut.topLeft.y).to(beCloseTo(162.37, within: 0.01))
            expect(sut.topRight.x).to(beCloseTo(792, within: 0.01))
            expect(sut.topRight.y) .to(beCloseTo(162.37, within: 0.01))
        }
        
        it("should correctly initialize the bottom arc") {
            expect(sut.bottomLeft.x).to(beCloseTo(243.2, within: 0.01))
            expect(sut.bottomLeft.y).to(beCloseTo(397.57, within: 0.01))
            expect(sut.bottomRight.x).to(beCloseTo(556.8, within: 0.01))
            expect(sut.bottomRight.y) .to(beCloseTo(397.57, within: 0.01))
        }
        
        describe("needle") {
            
            let middle = CGFloat.pi / 2
            let left = 3 * CGFloat.pi / 4
            let right = CGFloat.pi / 4
            let middleLeft = 5 * CGFloat.pi / 8
            let middleRight = 3 * CGFloat.pi / 8
        
            context("value is 0") {
                
                it("should set the needle to the middle of the dial") {
                    sut.value = 0
                    expect(sut.pointingTo).to(beCloseTo(middle))
                }
            
            }
            
            context("value is -0.5") {
                
                it("should set the needle to the middle of left part of the dial") {
                    sut.value = -0.5
                    expect(sut.pointingTo).to(beCloseTo(middleLeft))
                }
                
            }
            
            context("value is -1") {
                
                it("should set the needle to the left of the dial") {
                    sut.value = -1
                    expect(sut.pointingTo).to(beCloseTo(left))
                }
                
            }
            
            context("value is 0.5") {
                
                it("should set the needle middle of the right part of the dial") {
                    sut.value = 0.5
                    expect(sut.pointingTo).to(beCloseTo(middleRight))
                }
                
            }
            
            context("value is 1") {
                
                it("should set the needle to the right of the dial") {
                    sut.value = 1
                    expect(sut.pointingTo).to(beCloseTo(right))
                }
                
            }
            
            
            
        }
    }

}
