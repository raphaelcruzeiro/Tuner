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

class ViewController: UIViewController {
    
    let label = UILabel()
    var tuner: Tuner!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tuner.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: TunerDelegate {

    func didMatchNote(note: TunerKit.NoteMapper.Note) {
        label.text = "\(note.nameWithSharp)\nOctave: \(note.octave)\nAccuracy: \(note.accuracy)"
    }

}
