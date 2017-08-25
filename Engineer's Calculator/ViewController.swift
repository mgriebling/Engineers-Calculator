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
    
    @IBOutlet weak var boxBackdrop: NSBox!//{
//        didSet {
//            boxBackdrop.fillColor = NSColor.black
//        }
//    }
    
    @IBOutlet weak var aButton: SYFlatButton!
    @IBOutlet weak var bButton: SYFlatButton!
    @IBOutlet weak var cButton: SYFlatButton!
    @IBOutlet weak var dButton: SYFlatButton!
    @IBOutlet weak var leButton: SYFlatButton!
    @IBOutlet weak var neButton: SYFlatButton!
    @IBOutlet weak var dpButton: SYFlatButton!
    @IBOutlet weak var expButton: SYFlatButton!
    @IBOutlet weak var pmButton: SYFlatButton!
    @IBOutlet weak var percentButton: SYFlatButton!
    
    @IBOutlet weak var twoButton: SYFlatButton! {
        didSet {
            // pick up this colour
            numberColour = twoButton.backgroundNormalColor
        }
    }
    @IBOutlet weak var threeButton: SYFlatButton!
    @IBOutlet weak var fourButton: SYFlatButton!
    @IBOutlet weak var fiveButton: SYFlatButton!
    @IBOutlet weak var sixButton: SYFlatButton!
    @IBOutlet weak var sevenButton: SYFlatButton!
    @IBOutlet weak var eightButton: SYFlatButton!
    @IBOutlet weak var nineButton: SYFlatButton!
    
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
    @IBOutlet weak var divButton: SYFlatButton!
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
    var radix = 10
    var bits = 32 {
        didSet {
            digitsDisplay.setLabel("Bits: \(bits)", forSegment: 0)
        }
    }
    var digits = 25 {
        didSet {
            digitsDisplay.setLabel("Digits: \(digits)", forSegment: 0)
        }
    }
    
//    @IBAction func exitToHere() { } // stub to return to this view

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.setValue(false, forKey: "drawsBackground")
            webView.acceptsTouchEvents = false
            webView.allowsBackForwardNavigationGestures = false
        }
    }
    
    func setFFButton() {
        switch radix {
        case 2: expButton.title = "11"
        case 8: expButton.title = "77"
        case 16: expButton.title = "FF"
        default: expButton.title = "99"
        }
    }
    
    func setButton(_ button: SYFlatButton, label: String, color: NSColor, enabled: Bool) {
        button.title = label
        button.backgroundNormalColor = color
        if !enabled {
            button.imageNormalColor = NSColor.gray
            button.titleNormalColor = NSColor.gray
        } else {
            button.imageNormalColor = NSColor.black
            button.titleNormalColor = NSColor.black
        }
        button.isEnabled = enabled
    }
    
    func enableDigits() {
        setButton(twoButton,   label: "2", color: numberColour, enabled: radix > 2)
        setButton(threeButton, label: "3", color: numberColour, enabled: radix > 3)
        setButton(fourButton,  label: "4", color: numberColour, enabled: radix > 4)
        setButton(fiveButton,  label: "5", color: numberColour, enabled: radix > 5)
        setButton(sixButton,   label: "6", color: numberColour, enabled: radix > 6)
        setButton(sevenButton, label: "7", color: numberColour, enabled: radix > 7)
        setButton(eightButton, label: "8", color: numberColour, enabled: radix > 8)
        setButton(nineButton,  label: "9", color: numberColour, enabled: radix > 9)
        setButton(aButton,     label: "A", color: numberColour, enabled: radix > 10)
        setButton(bButton,     label: "B", color: numberColour, enabled: radix > 11)
        setButton(cButton,     label: "C", color: numberColour, enabled: radix > 12)
        setButton(dButton,     label: "D", color: numberColour, enabled: radix > 13)
        setButton(pmButton,    label: "E", color: numberColour, enabled: radix > 14)
        setButton(percentButton, label: "F", color: numberColour, enabled: radix > 15)
    }

    @IBAction func radixChanged(_ sender: NSSegmentedControl) {
        if keypad == 2 { setFFButton() }
        switch sender.integerValue {
        case 0: radix = 2
        case 1: radix = 8
        case 3: radix = 16
        default: radix = 10
        }
        enableDigits()
    }
    
    func setKeypadLabels(_ mode: Int) {
        radixControl.isEnabled = false
        degRadGradControl.isEnabled = true
        numberModeControl.isEnabled = true
        switch mode {
        case 0: // math mode
            radix = 10
            enableDigits()
            setButton(aButton, label: "→rθ", color: functionColour, enabled: true)
            setButton(bButton, label: ">", color: functionColour, enabled: true)
            setButton(cButton, label: "<", color: functionColour, enabled: true)
            setButton(dButton, label: "≥", color: functionColour, enabled: true)
            setButton(pmButton, label: "⁺⁄-", color: functionColour, enabled: true)
            setButton(percentButton, label: "%", color: functionColour, enabled: true)
            toiButton.title = "→𝒊"
            dpButton.title = "."
            leButton.title = "≤"
            neButton.title = "≠"
            expButton.title = "EE"
            sinhButton.title = "sinh"
            coshButton.title = "cosh"; coshButton.image = nil
            tanhButton.title = "tanh"; tanhButton.image = nil
            sinButton.title = "sin"; sinButton.image = nil
            cosButton.title = "cos"; cosButton.image = nil
            tanButton.title = "tan"; tanButton.image = nil
            intButton.title = "int"
            fracButton.title = "frac"
            divButton.title = "div"
            iButton.title = "let"
            exButton.title = ","
            piButton.title = "="
            sqrtButton.image = NSImage(named: "sqrt"); sqrtButton.title = ""
            cbrtButton.image = NSImage(named: "cbrt"); cbrtButton.title = ""
            nRootButton.image = NSImage(named: "nroot"); nRootButton.title = ""
            log10Button.image = NSImage(named: "log10"); log10Button.title = ""
            log2Button.image = NSImage(named: "log2"); log2Button.title = ""
            reciprocalButton.image = NSImage(named: "inverse"); reciprocalButton.title = ""
            etoxButton.image = NSImage(named: "powerOf"); etoxButton.title = ""
            lnButton.image = NSImage(named: "log"); lnButton.title = ""
            logyButton.image = NSImage(named: "logy"); logyButton.title = ""
            asinhButton.image = NSImage(named: "asinh"); asinhButton.title = ""
            acoshButton.image = NSImage(named: "acosh"); acoshButton.title = ""
            atanhButton.image = NSImage(named: "atanh"); atanhButton.title = ""
            asinButton.image = NSImage(named: "asin"); asinButton.title = ""
            acosButton.image = NSImage(named: "acos"); acosButton.title = ""
            atanButton.image = NSImage(named: "atan"); atanButton.title = ""
            reButton.title = "re"
            imButton.title = "im"
            digits += 0  // refresh digits display
        case 1: // statistic mode
            radix = 10
            enableDigits()
            setButton(aButton, label: "→rθ", color: functionColour, enabled: true)
            setButton(bButton, label: ">", color: functionColour, enabled: true)
            setButton(cButton, label: "<", color: functionColour, enabled: true)
            setButton(dButton, label: "≥", color: functionColour, enabled: true)
            setButton(pmButton, label: "⁺⁄-", color: functionColour, enabled: true)
            setButton(percentButton, label: "%", color: functionColour, enabled: true)
            dpButton.title = "."
            leButton.title = "≤"
            neButton.title = "≠"
            expButton.title = "EE"
            sinhButton.title = "n"
            coshButton.title = ""; coshButton.image = NSImage(named: "sumx")
            tanhButton.title = ""; tanhButton.image = NSImage(named: "sumy")
            sinButton.title = ""; sinButton.image = NSImage(named: "sumx2")
            cosButton.title = ""; cosButton.image = NSImage(named: "sumxy")
            tanButton.title = ""; tanButton.image = NSImage(named: "sumy2")
            intButton.title = "int"
            fracButton.title = "frac"
            divButton.title = "div"
            iButton.title = "let"
            exButton.title = ","
            piButton.title = "="
            reciprocalButton.image = NSImage(named: "inverse"); reciprocalButton.title = ""
            etoxButton.image = NSImage(named: "powerOf"); etoxButton.title = ""
            sqrtButton.image = NSImage(named: "sqrt"); sqrtButton.title = ""
            cbrtButton.image = NSImage(named: "cbrt"); cbrtButton.title = ""
            nRootButton.image = NSImage(named: "nroot"); nRootButton.title = ""
            log10Button.title = ""; log10Button.image = NSImage(named: "stddevx")
            log2Button.title = ""; log2Button.image = NSImage(named: "stddevy")
            lnButton.title = ""; lnButton.image = NSImage(named: "sigmax")
            logyButton.title = ""; logyButton.image = NSImage(named: "sigmay")
            asinhButton.title = "→x"; asinhButton.image = nil
            acoshButton.title = "→y"; acoshButton.image = nil
            atanhButton.title = "→x,y"; atanhButton.image = nil
            asinButton.title = ""; asinButton.image = NSImage(named: "xmean")
            acosButton.title = ""; acosButton.image = NSImage(named: "ymean")
            atanButton.title = "CD"; atanButton.image = nil
            reButton.title = "nPr"
            imButton.title = "nCr"
        default: // programmer mode
            enableDigits()
            toiButton.title = "mod"
            dpButton.title = "00"
            leButton.title = "CE"
            neButton.title = "radix"
            setFFButton()
            sinhButton.title = "and"
            coshButton.title = "or"; coshButton.image = nil
            tanhButton.title = "xor"; tanhButton.image = nil
            sinButton.title = "<<"; sinButton.image = nil
            cosButton.title = ">>"; cosButton.image = nil
            tanButton.title = "gcd"; tanButton.image = nil
            intButton.title = "rol"
            fracButton.title = "ror"
            divButton.title = "luc"
            iButton.title = "let"
            exButton.title = ","
            piButton.title = "="
            sqrtButton.title = "cbit"; sqrtButton.image = nil
            cbrtButton.title = "sbit"; cbrtButton.image = nil
            nRootButton.title = "tbit"; nRootButton.image = nil
            log10Button.title = "bit"; log10Button.image = nil
            log2Button.title = "cnt"; log2Button.image = nil
            reciprocalButton.title = "odd"; reciprocalButton.image = nil
            etoxButton.title = "fib"; etoxButton.image = nil
            lnButton.title = "1’s"; lnButton.image = nil
            logyButton.title = "2’s"; logyButton.image = nil
            asinhButton.title = "nand"; asinhButton.image = nil
            acoshButton.title = "nor"; acoshButton.image = nil
            atanhButton.title = "xnor"; atanhButton.image = nil
            asinButton.title = "<<1"; asinButton.image = nil
            acosButton.title = ">>1"; acosButton.image = nil
            atanButton.title = "lcm"; atanButton.image = nil
            reButton.title = "bit⇔"
            imButton.title = "byt⇔"
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Show Radix" && keypad != 2 {
            return false
        }
        return true
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
            if self.keypad != 2 {
                vc.digits = self.digits
                vc.bits = 0
                vc.callback = { digits in
                    self.digits = digits
                }
            } else {
                vc.digits = 0
                vc.bits = self.bits
                vc.callback = { digits in
                    self.bits = digits
                }
            }
        } else if segue.identifier == "Show Radix" {
            let vc = segue.destinationController as! RadixController
            vc.callback = { prefix in
                self.equation += prefix
                self.updateDisplay()
            }
        }
    }
    
    

}


