//
//  NoteMapperSpec.swift
//  TunnerKit
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import TunnerKit

class NoteMapperSpec: QuickSpec {

    override func spec() {
        
        var sut: NoteMapper!
        
        beforeEach {
            sut = NoteMapper()
        }
    
        describe("initialization") {
        
            it("should calculate the base frequency") {
                expect(sut.referenceFrequency).to(beCloseTo(27.5, within: 0.01))
            }
            
            it("should initialize the frequency table") {
                expect(sut.frequencyTable.first?.nameWithSharp).to(equal("C"))
                expect(sut.frequencyTable.first?.octave).to(equal(0))
                expect(sut.frequencyTable.first?.frequency).to(beCloseTo(16.35, within: 0.01))
                expect(sut.frequencyTable.last?.nameWithSharp).to(equal("B"))
                expect(sut.frequencyTable.last?.octave).to(equal(8))
                expect(sut.frequencyTable.last?.frequency).to(beCloseTo(7902.13, within: 0.01))
            }
        
        }
        
        describe("helper methods") {
        
            describe("note calculation") {
        
                let A = NoteMapper.Note(nameWithSharp: "A", nameWithFlat: "A", frequency: 440, octave: 4)
                
                it("should calculate one half step bellow A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: -1)
                    expect(result.frequency).to(beCloseTo(415.3, within: 0.01))
                    expect(result.nameWithSharp).to(equal("G♯"))
                    expect(result.nameWithFlat).to(equal("A♭"))
                    expect(result.octave).to(equal(4))
                }
                
                it("should calculate one half step above A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: 1)
                    expect(result.frequency).to(beCloseTo(466.16, within: 0.01))
                    expect(result.nameWithSharp).to(equal("A♯"))
                    expect(result.nameWithFlat).to(equal("B♭"))
                    expect(result.octave).to(equal(4))
                }
                
                it("should calculate five half steps above A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: 5)
                    expect(result.frequency).to(beCloseTo(587.33, within: 0.01))
                    expect(result.nameWithSharp).to(equal("D"))
                    expect(result.nameWithFlat).to(equal("D"))
                    expect(result.octave).to(equal(5))
                }
                
                it("should calculate five half steps bellow A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: -5)
                    expect(result.frequency).to(beCloseTo(329.63, within: 0.01))
                    expect(result.nameWithSharp).to(equal("E"))
                    expect(result.nameWithFlat).to(equal("E"))
                    expect(result.octave).to(equal(4))
                }
                
                it("should calculate five half steps bellow A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: -5)
                    expect(result.frequency).to(beCloseTo(329.63, within: 0.01))
                    expect(result.nameWithSharp).to(equal("E"))
                    expect(result.nameWithFlat).to(equal("E"))
                    expect(result.octave).to(equal(4))
                }
                
                it("should calculate 14 half steps bellow A correctly") {
                    let result = sut.calculateNote(from: A, halfSteps: -14)
                    expect(result.frequency).to(beCloseTo(196, within: 0.01))
                    expect(result.nameWithSharp).to(equal("G"))
                    expect(result.nameWithFlat).to(equal("G"))
                    expect(result.octave).to(equal(3))
                }
            }
        
        }
        
    }

}
