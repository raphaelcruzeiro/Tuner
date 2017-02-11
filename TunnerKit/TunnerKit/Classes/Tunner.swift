//
//  Tunner.swift
//  TunnerKit
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import AudioKit

public class Tunner {

    private var microphone: AKMicrophone!
    private var tracker: AKFrequencyTracker!
    private var silence: AKBooster!
    private var timer: Timer?
    
    public init() {
        AKSettings.audioInputEnabled = true
        
        microphone = AKMicrophone()
        tracker = AKFrequencyTracker(microphone)
        silence = AKBooster(tracker, gain: 0)
    }
    
    public func start() {
        AudioKit.output = silence
        AudioKit.start()
        
        timer = Timer(timeInterval: 0.3, target: self, selector: #selector(Tunner.timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick() {
        if tracker.amplitude > 0.1 {
            let frequency = tracker.frequency
        }
    }
    
}
