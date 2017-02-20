//
//  Tuner.swift
//  TunerKit
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import AudioKit

public protocol TunerDelegate: NSObjectProtocol {
    func didMatchNote(note: NoteMapper.Note)
}

public class Tuner {

    private var microphone: AKMicrophone!
    private var tracker: AKFrequencyTracker!
    private var silence: AKBooster!
    private var timer: Timer?
    private var noteMapper: NoteMapper!

    public weak var delegate: TunerDelegate?
    
    public init() {}

    var referenceFrequency: Double = 440 {
        didSet {
            noteMapper = NoteMapper(referenceFrequency: referenceFrequency)
        }
    }

    deinit {
        stop()
    }

    public func start() {
        AKSettings.audioInputEnabled = true
        
        microphone = AKMicrophone()
        tracker = AKFrequencyTracker(microphone)
        silence = AKBooster(tracker, gain:  0)
        
        noteMapper = NoteMapper(referenceFrequency: referenceFrequency)
        
        AudioKit.output = silence
        AudioKit.start()
        microphone.start()
        tracker.start()
        

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] _ in
            print(self.tracker.amplitude)
            if self.tracker.amplitude > 0.05 {
                let note = self.noteMapper.note(for: self.tracker.frequency)
                self.delegate?.didMatchNote(note: note)
            }
        }
    }

    public func stop() {
        AudioKit.stop()
        timer?.invalidate()
    }

}
