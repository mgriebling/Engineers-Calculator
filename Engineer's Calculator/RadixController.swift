//
//  RadixController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 25 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa

class RadixController: NSViewController {

    var radix: Int = 10
    var callback: (_ prefix: String) -> () = { _ in }   // callback
    
    @IBOutlet weak var radixLabel: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var insertButton: SYFlatButton!
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        radix = sender.integerValue
        update()
    }
    
    func update() {
        slider.integerValue = radix
        radixLabel.stringValue = "Radix: \(radix)"
        insertButton.title = "Insert '\(getPrefix())'"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func getPrefix() -> String {
        let prefix: String
        switch radix {
        case 2: prefix = "0b"
        case 10: prefix = "0d"
        case 8: prefix = "0o"
        case 16: prefix = "0x"
        default: prefix = "#\(radix)#"
        }
        return prefix
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        callback(getPrefix())
    }
    
}
