//
//  DigitController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 21 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa

class DigitController: NSViewController {
    
    var digits: Int = 0
    var bits: Int = 0
    var callback: (_ digits: Int) -> () = { _ in }   // callback

    @IBOutlet weak var digitsLabel: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        if digits != 0 {
            digits = sender.integerValue
        } else {
            bits = sender.integerValue
        }
        update()
    }
    
    func update() {
        if digits != 0 {
            slider.integerValue = digits
            digitsLabel.stringValue = "Digits: \(digits)"
            callback(digits)
        } else {
            slider.integerValue = bits
            digitsLabel.stringValue = "Bits: \(bits)"
            callback(bits)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
}
