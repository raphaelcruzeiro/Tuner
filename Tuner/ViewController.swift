//
//  ViewController.swift
//  Tuner
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import UIKit
import Cartography
import TunerKit
import AudioKit
import pop

class ViewController: UIViewController {

    let noteLabel = UILabel()
    let octaveLabel = UILabel()
    let label = UILabel()
    let meterView = VUMeterView()

    var tuner: Tuner!

    var plot: UIView?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        view.addSubview(noteLabel)
        view.addSubview(octaveLabel)
        view.addSubview(meterView)

        constrain(view, noteLabel, meterView, octaveLabel) { view, label, meter, octave in
            label.top == view.top + 120
            label.height == 50
            label.left == view.left
            label.right == view.right

            meter.top == label.bottom + 190
            meter.left == view.left
            meter.right == view.right
            meter.height == 210

            octave.height == label.height / 3
            octave.width == 30
            octave.top == label.bottom + 50
            octave.centerX == view.centerX
        }

        noteLabel.textColor = .white
        noteLabel.font = .systemFont(ofSize: 75)
        noteLabel.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.numberOfLines = 0
        octaveLabel.textColor = .white
        octaveLabel.textAlignment = .center
        octaveLabel.font = .systemFont(ofSize: 22)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let env = ProcessInfo.processInfo.environment

        // Since AudioKit will try to access the microphone upon being initialized,
        // a system dialog asking for microphone permission will appear and this
        // causes the Simulator to hang on TravisCI. This is a workaround for that
        // issue so that the tests can be run.
        if env["HOME"]?.contains("travis") ?? false {
            return
        }

        tuner = Tuner()
        tuner.delegate = self
        tuner.start()

        plot?.removeFromSuperview()

        plot = tuner.plot(
            frame: CGRect(
                x: 0,
                y: view.frame.height / 2 + 100,
                width: view.frame.size.width,
                height: 300
            )
        )

        guard let plot = plot as? AKNodeOutputPlot else { return }
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.color = .white
        plot.backgroundColor = .clear
        view.addSubview(plot)

        meterView.value = -1
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tuner.stop()
        tuner = nil
    }

    fileprivate func popNoteLabel() {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)!
        animation.springBounciness = 20
        animation.toValue = NSValue(cgSize: CGSize(width: 2, height: 2))
        animation.removedOnCompletion = true

        let backToNormalAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)!
        backToNormalAnimation.springBounciness = 20
        backToNormalAnimation.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        backToNormalAnimation.removedOnCompletion = true

        animation.completionBlock = { _, finished in
            if finished {
                self.noteLabel.pop_add(backToNormalAnimation, forKey: "pop")
            }
        }

        noteLabel.pop_add(animation, forKey: "pop")
    }

    fileprivate func flashBackground() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0.8, blue: 0, alpha: 1)
        }, completion: nil)
    }

    fileprivate func fadeBackground() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = .black
        }, completion: nil)
    }

}

extension ViewController: TunerDelegate {

    func didLostNote() {
        fadeBackground()
        meterView.value = -1
    }

    func didMatchNote(note: TunerKit.NoteMapper.Note) {
        noteLabel.text = note.nameWithSharp
        octaveLabel.text = "\(note.octave)"
        meterView.value = note.accuracy

        if note.accuracy > -0.1 && note.accuracy < 0.1 {
            popNoteLabel()
            flashBackground()
        } else {
            fadeBackground()
        }
    }

}
