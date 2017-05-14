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
    func didLostNote()
}

public class Tuner {

    private var microphone: AKMicrophone!
    private var tracker: AKFrequencyTracker!
    private var silence: AKBooster!
    private var timer: Timer?
    private var noteMapper: NoteMapper!
    private var hasMatchedNote = false

    public weak var delegate: TunerDelegate?

    public init() {}

    var referenceFrequency: Double = 440 {
        didSet {
            noteMapper = NoteMapper(referenceFrequency: referenceFrequency)
        }
    }

    public func plot(frame: CGRect) -> AKNodeOutputPlot? {
        return AKNodeOutputPlot(microphone, frame: frame)
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
            if self.tracker.amplitude > 0.06 {
                self.hasMatchedNote = true
                let note = self.noteMapper.note(for: self.tracker.frequency)
                self.delegate?.didMatchNote(note: note)
            } else if self.hasMatchedNote {
                self.hasMatchedNote = false
                self.delegate?.didLostNote()
            }
        }
    }

    public func stop() {
        AudioKit.stop()
        timer?.invalidate()
    }

}
