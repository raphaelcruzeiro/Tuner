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

class ViewController: UIViewController {

    let label = UILabel()
    var tuner: Tuner!

    var plot: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        view.backgroundColor = .white

        constrain(view, label) { view, label in
            label.centerY == view.centerY
            label.height == 200
            label.left == view.left
            label.right == view.right
        }

        tuner = Tuner()
        tuner.delegate = self

        label.textAlignment = .center
        label.numberOfLines = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tuner.start()

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
        plot.shouldMirror = true
        plot.color = UIColor.blue
        view.addSubview(plot)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tuner.stop()
    }

}

extension ViewController: TunerDelegate {

    func didMatchNote(note: TunerKit.NoteMapper.Note) {
        label.text = "\(note.nameWithSharp)\nOctave: \(note.octave)\nAccuracy: \(note.accuracy)"
    }

}
