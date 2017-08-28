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
    var subscriptActive = false
    
    @IBOutlet weak var aButton: SYFlatButton!
    @IBOutlet weak var bButton: SYFlatButton!
    @IBOutlet weak var cButton: SYFlatButton!
    @IBOutlet weak var dButton: SYFlatButton!
    @IBOutlet weak var eButton: SYFlatButton!
    @IBOutlet weak var fButton: SYFlatButton!
    @IBOutlet weak var gButton: SYFlatButton!
    @IBOutlet weak var hButton: SYFlatButton!
    @IBOutlet weak var iButton: SYFlatButton!
    @IBOutlet weak var jButton: SYFlatButton!
    @IBOutlet weak var kButton: SYFlatButton!
    @IBOutlet weak var lButton: SYFlatButton!
    @IBOutlet weak var mButton: SYFlatButton!
    @IBOutlet weak var nButton: SYFlatButton!
    @IBOutlet weak var oButton: SYFlatButton!
    @IBOutlet weak var pButton: SYFlatButton!
    @IBOutlet weak var qButton: SYFlatButton!
    @IBOutlet weak var rButton: SYFlatButton!
    @IBOutlet weak var sButton: SYFlatButton!
    @IBOutlet weak var tButton: SYFlatButton!
    @IBOutlet weak var uButton: SYFlatButton!
    @IBOutlet weak var vButton: SYFlatButton!
    @IBOutlet weak var wButton: SYFlatButton!
    @IBOutlet weak var xButton: SYFlatButton!
    @IBOutlet weak var yButton: SYFlatButton!
    @IBOutlet weak var zButton: SYFlatButton!
    
    @IBAction func letterPressed(_ sender: SYFlatButton) {
        if subscriptActive {
            keyPressed("<sub>" + sender.title + "</sub>")
        } else {
            keyPressed(sender.title)
        }
    }
 
    @IBAction func subscriptPressed(_ sender: SYFlatButton) {
        subscriptActive = sender.intValue == 1
    }
    
    @IBAction func capPressed(_ sender: SYFlatButton) {
        if sender.intValue == 1 {
            aButton.title = "A"
            bButton.title = "B"
            cButton.title = "C"
            dButton.title = "D"
            eButton.title = "E"
            fButton.title = "F"
            gButton.title = "G"
            hButton.title = "H"
            iButton.title = "I"
            jButton.title = "J"
            kButton.title = "K"
            lButton.title = "L"
            mButton.title = "M"
            nButton.title = "N"
            oButton.title = "O"
            pButton.title = "P"
            qButton.title = "Q"
            rButton.title = "R"
            sButton.title = "S"
            tButton.title = "T"
            uButton.title = "U"
            vButton.title = "V"
            wButton.title = "W"
            xButton.title = "X"
            yButton.title = "Y"
            zButton.title = "Z"
        } else {
            aButton.title = "a"
            bButton.title = "b"
            cButton.title = "c"
            dButton.title = "d"
            eButton.title = "e"
            fButton.title = "f"
            gButton.title = "g"
            hButton.title = "h"
            iButton.title = "i"
            jButton.title = "j"
            kButton.title = "k"
            lButton.title = "l"
            mButton.title = "m"
            nButton.title = "n"
            oButton.title = "o"
            pButton.title = "p"
            qButton.title = "q"
            rButton.title = "r"
            sButton.title = "s"
            tButton.title = "t"
            uButton.title = "u"
            vButton.title = "v"
            wButton.title = "w"
            xButton.title = "x"
            yButton.title = "y"
            zButton.title = "z"
        }
    }

}
