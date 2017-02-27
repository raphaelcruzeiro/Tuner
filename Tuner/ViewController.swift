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
    let label = UILabel()
    let meterView = VUMeterView()

    var tuner: Tuner!

    var plot: UIView?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        view.addSubview(noteLabel)
        view.addSubview(meterView)

        constrain(view, noteLabel, meterView) { view, label, meter in
            label.top == view.top + 120
            label.height == 200
            label.left == view.left
            label.right == view.right

            meter.top == label.bottom + 40
            meter.left == view.left
            meter.right == view.right
            meter.height == 210
        }

        tuner = Tuner()
        tuner.delegate = self

        noteLabel.textColor = .white
        noteLabel.font = .systemFont(ofSize: 75)
        noteLabel.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.numberOfLines = 0
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
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tuner.stop()
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

}

extension ViewController: TunerDelegate {

    func didMatchNote(note: TunerKit.NoteMapper.Note) {
        noteLabel.text = note.nameWithSharp
        meterView.value = note.accuracy

        if note.accuracy > -0.1 && note.accuracy < 0.1 {
            popNoteLabel()
        }
    }

}
