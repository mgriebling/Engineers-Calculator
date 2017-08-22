//
//  LetterPadController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 21 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa

class LetterPadController: NSViewController {
    
    var keyPressed: (_ s: String) -> () = { _ in }   // callback
    
    @IBAction func letterPressed(_ sender: SYFlatButton) {
        keyPressed(sender.title)
    }
    
}
