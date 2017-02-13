//
//  Tunner.swift
//  TunnerKit
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import Foundation
import AudioKit

public protocol TunnerDelegate: NSObjectProtocol {
    func didMatchNote(note: NoteMapper.Note)
}

public class Tunner {

    private var microphone: AKMicrophone!
    private var tracker: AKFrequencyTracker!
    private var silence: AKBooster!
    private var timer: Timer?
    private var noteMapper: NoteMapper!

    public weak var delegate: TunnerDelegate?

    var referenceFrequency: Double = 440 {
        didSet {
            noteMapper = NoteMapper(referenceFrequency: referenceFrequency)
        }
    }

    public init() {
        AKSettings.audioInputEnabled = true

        microphone = AKMicrophone()
        tracker = AKFrequencyTracker(microphone)
        silence = AKBooster(tracker, gain: 0)

        noteMapper = NoteMapper(referenceFrequency: referenceFrequency)
    }

    deinit {
        stop()
    }

    public func start() {
        AudioKit.output = silence
        AudioKit.start()

        timer = Timer(
            timeInterval: 0.3,
            target: self,
            selector: #selector(Tunner.timerTick),
            userInfo: nil,
            repeats: true
        )
    }

    public func stop() {
        AudioKit.stop()
        timer?.invalidate()
    }

    @objc func timerTick() {
        if tracker.amplitude > 0.1 {
            let note = noteMapper.note(for: tracker.frequency)
            delegate?.didMatchNote(note: note)
        }
    }

}
