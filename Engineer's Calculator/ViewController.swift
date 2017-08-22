//
//  ViewController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 20 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKUIDelegate {
    
    @IBOutlet weak var aButton: SYFlatButton!
    @IBOutlet weak var bButton: SYFlatButton!
    @IBOutlet weak var cButton: SYFlatButton!
    @IBOutlet weak var dButton: SYFlatButton!
    @IBOutlet weak var eButton: SYFlatButton!
    @IBOutlet weak var fButton: SYFlatButton!
    @IBOutlet weak var dpButton: SYFlatButton!
    @IBOutlet weak var expButton: SYFlatButton!
    @IBOutlet weak var pmButton: SYFlatButton!
    @IBOutlet weak var percentButton: SYFlatButton!
    
    @IBOutlet weak var zeroButton: SYFlatButton! {
        didSet {
            // pick up this colour
            numberColour = zeroButton.backgroundNormalColor
        }
    }
    
    @IBOutlet weak var sinhButton: SYFlatButton! {
        didSet {
            // pick up this colour
            functionColour = sinhButton.backgroundNormalColor
        }
    }
    @IBOutlet weak var coshButton: SYFlatButton!
    @IBOutlet weak var tanhButton: SYFlatButton!
    @IBOutlet weak var sinButton: SYFlatButton!
    @IBOutlet weak var cosButton: SYFlatButton!
    @IBOutlet weak var tanButton: SYFlatButton!
    @IBOutlet weak var asinhButton: SYFlatButton!
    @IBOutlet weak var acoshButton: SYFlatButton!
    @IBOutlet weak var atanhButton: SYFlatButton!
    @IBOutlet weak var asinButton: SYFlatButton!
    @IBOutlet weak var acosButton: SYFlatButton!
    @IBOutlet weak var atanButton: SYFlatButton!
    @IBOutlet weak var intButton: SYFlatButton!
    @IBOutlet weak var fracButton: SYFlatButton!
    @IBOutlet weak var reButton: SYFlatButton!
    @IBOutlet weak var imButton: SYFlatButton!
    @IBOutlet weak var toiButton: SYFlatButton!
    
    @IBOutlet weak var iButton: SYFlatButton!
    @IBOutlet weak var exButton: SYFlatButton!
    @IBOutlet weak var piButton: SYFlatButton!
    @IBOutlet weak var sqrtButton: SYFlatButton!
    @IBOutlet weak var cbrtButton: SYFlatButton!
    @IBOutlet weak var nRootButton: SYFlatButton!
    @IBOutlet weak var log10Button: SYFlatButton!
    @IBOutlet weak var log2Button: SYFlatButton!
    @IBOutlet weak var lnButton: SYFlatButton!
    @IBOutlet weak var logyButton: SYFlatButton!
    @IBOutlet weak var etoxButton: SYFlatButton!
    @IBOutlet weak var reciprocalButton: SYFlatButton!
    
    @IBOutlet weak var digitsDisplay: NSSegmentedControl!
    @IBOutlet weak var radixControl: NSSegmentedControl!
    @IBOutlet weak var degRadGradControl: NSSegmentedControl!
    @IBOutlet weak var numberModeControl: NSSegmentedControl!
    
    var numberColour = NSColor.white    // replaced during loading
    var functionColour = NSColor.white  // replaced during loading
    
    var equation = ""
    var result = ""
    var keypad = 0
    var bits = 32 {
        didSet {
            digitsDisplay.setLabel("Bits: \(digits)", forSegment: 0)
        }
    }
    var digits = 25 {
        didSet {
            digitsDisplay.setLabel("Digits: \(digits)", forSegment: 0)
        }
    }

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.setValue(false, forKey: "drawsBackground")
            webView.acceptsTouchEvents = false
            webView.allowsBackForwardNavigationGestures = false
        }
    }
    
    func setFFButton() {
        let choice = radixControl.integerValue
        switch choice {
        case 0: expButton.title = "11"
        case 1: expButton.title = "77"
        case 3: expButton.title = "FF"
        default: expButton.title = "99"
        }
    }

    @IBAction func radixChanged(_ sender: NSSegmentedControl) {
        if keypad == 2 { setFFButton() }
    }
    
    func setKeypadLabels(_ mode: Int) {
        radixControl.isEnabled = false
        degRadGradControl.isEnabled = true
        numberModeControl.isEnabled = true
        switch mode {
        case 0: // math mode
            aButton.title = "→rθ"; aButton.backgroundNormalColor = functionColour
            toiButton.title = "→𝒊"
            bButton.title = ">"; bButton.backgroundNormalColor = functionColour
            cButton.title = "<"; cButton.backgroundNormalColor = functionColour
            dButton.title = "≥"; dButton.backgroundNormalColor = functionColour
            eButton.title = "≤"
            fButton.title = "≠"
            pmButton.title = "⁺⁄-"; pmButton.backgroundNormalColor = functionColour
            percentButton.title = "%"; percentButton.backgroundNormalColor = functionColour
            dpButton.title = "."
            expButton.title = "EE"
            sinhButton.title = "sinh"
            coshButton.title = "cosh"
            tanhButton.title = "tanh"
            sinButton.title = "sin"
            cosButton.title = "cos"
            tanButton.title = "tan"
            intButton.title = "int"
            fracButton.title = "frac"
            iButton.title = "𝒊"
            exButton.title = "𝒆"
            piButton.title = "𝛑"
            lnButton.image = NSImage(named: "ln"); lnButton.title = ""
            logyButton.image = NSImage(named: "logy"); logyButton.title = ""
            asinhButton.image = NSImage(named: "asinh"); asinhButton.title = ""
            acoshButton.image = NSImage(named: "acosh"); acoshButton.title = ""
            atanhButton.image = NSImage(named: "atanh"); atanhButton.title = ""
            asinButton.image = NSImage(named: "asin"); asinButton.title = ""
            acosButton.image = NSImage(named: "acos"); acosButton.title = ""
            atanButton.image = NSImage(named: "atan"); atanButton.title = ""
            digits += 0  // refresh digits display
        case 1: break
        default: // programmer mode
            aButton.title = "A"; aButton.backgroundNormalColor = numberColour
            toiButton.title = "mod"
            bButton.title = "B"; bButton.backgroundNormalColor = numberColour
            cButton.title = "C"; cButton.backgroundNormalColor = numberColour
            dButton.title = "D"; dButton.backgroundNormalColor = numberColour
            pmButton.title = "E"; pmButton.backgroundNormalColor = numberColour
            percentButton.title = "F"; percentButton.backgroundNormalColor = numberColour
            dpButton.title = "00"
            setFFButton()
            sinhButton.title = "and"
            coshButton.title = "or"
            tanhButton.title = "xor"
            sinButton.title = "<<"
            cosButton.title = ">>"
            tanButton.title = ""
            intButton.title = "rol"
            fracButton.title = "ror"
            iButton.title = "0x"
            exButton.title = "0o"
            piButton.title = "0b"
            lnButton.title = "1’s"; lnButton.image = nil
            logyButton.title = "2’s"; logyButton.image = nil
            asinhButton.title = "nand"; asinhButton.image = nil
            acoshButton.title = "nor"; acoshButton.image = nil
            atanhButton.title = "xnor"; atanhButton.image = nil
            asinButton.title = "<<1"; asinButton.image = nil
            acosButton.title = ">>1"; acosButton.image = nil
            atanButton.title = ""; atanButton.image = nil
            bits += 0  // refresh bits display
            radixControl.isEnabled = true
            degRadGradControl.isEnabled = false
            numberModeControl.isEnabled = false
        }
    }
    
    func updateDisplay() {
        let content = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><title>Equation #1</title>" +
        "</head><body text=\"white\"><font face=\"Helvetica Neue\" size=\"6\">\(equation)<font face=\"Helvetica Neue\" size=\"2\">" +
        "<p align=\"right\"><font face=\"Helvetica Neue\" size=\"5\">\(result) &emsp;</p></body></html>"
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    @IBAction func keypadChanged(_ sender: NSSegmentedControl) {
        keypad = sender.integerValue
        setKeypadLabels(sender.integerValue)
    }
    
    @IBAction func keyPressed(_ sender: SYFlatButton) {
        equation += sender.title
        updateDisplay()
    }
    
    @IBAction func equalPressed(_ sender: SYFlatButton) {
        result = equation
        updateDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        equation = "&emsp;"
        result = "0"
        updateDisplay()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show LetterPad" {
            let vc = segue.destinationController as! LetterPadController
            vc.keyPressed = { key in
                self.equation += key
                self.updateDisplay()
            }
        } else if segue.identifier == "Show Digits" {
            let vc = segue.destinationController as! DigitController
            vc.digits = self.digits
            vc.callback = { digits in
                if self.keypad == 2 {
                    self.digits = digits
                } else {
                    self.bits = digits
                }
            }
        }
    }
    
    

}


