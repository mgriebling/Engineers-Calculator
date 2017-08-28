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
    
    @IBOutlet weak var boxBackdrop: NSBox!
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
            ViewController.numberColour = twoButton.backgroundNormalColor
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
            ViewController.functionColour = sinhButton.backgroundNormalColor
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
    
    static var numberColour : NSColor = NSColor.white    // replaced during loading
    static var functionColour : NSColor = NSColor.white  // replaced during loading
    
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
    
    func setEnable(_ button: SYFlatButton, enabled: Bool = true) {
        if !enabled {
            button.imageNormalColor = NSColor.gray
            button.titleNormalColor = NSColor.gray
        } else {
            button.imageNormalColor = NSColor.black
            button.titleNormalColor = NSColor.black
        }
        button.isEnabled = enabled
    }
    
    func setButton(_ button: SYFlatButton, label: String, color: NSColor = functionColour, enabled: Bool = true) {
        button.title = label
        button.image = nil
        button.backgroundNormalColor = color
        setEnable(button)
    }
    
    func setButton(_ button: SYFlatButton, image: NSImage?, color: NSColor = functionColour, enabled: Bool = true) {
        button.title = ""
        button.image = image!
        button.backgroundNormalColor = color
        setEnable(button)
    }
    
    func enableDigits() {
        setButton(twoButton,     label: "2", color: ViewController.numberColour, enabled: radix > 2)
        setButton(threeButton,   label: "3", color: ViewController.numberColour, enabled: radix > 3)
        setButton(fourButton,    label: "4", color: ViewController.numberColour, enabled: radix > 4)
        setButton(fiveButton,    label: "5", color: ViewController.numberColour, enabled: radix > 5)
        setButton(sixButton,     label: "6", color: ViewController.numberColour, enabled: radix > 6)
        setButton(sevenButton,   label: "7", color: ViewController.numberColour, enabled: radix > 7)
        setButton(eightButton,   label: "8", color: ViewController.numberColour, enabled: radix > 8)
        setButton(nineButton,    label: "9", color: ViewController.numberColour, enabled: radix > 9)
        setButton(aButton,       label: "A", color: ViewController.numberColour, enabled: radix > 10)
        setButton(bButton,       label: "B", color: ViewController.numberColour, enabled: radix > 11)
        setButton(cButton,       label: "C", color: ViewController.numberColour, enabled: radix > 12)
        setButton(dButton,       label: "D", color: ViewController.numberColour, enabled: radix > 13)
        setButton(pmButton,      label: "E", color: ViewController.numberColour, enabled: radix > 14)
        setButton(percentButton, label: "F", color: ViewController.numberColour, enabled: radix > 15)
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
            setButton(aButton, label: "→rθ")
            setButton(bButton, label: ">")
            setButton(cButton, label: "<")
            setButton(dButton, label: "≥")
            setButton(percentButton, label: "%")
            setButton(pmButton, label: "⌫")
            toiButton.title = "→𝒊"
            dpButton.title = "."
            leButton.title = "≤"
            neButton.title = "≠"
            expButton.title = "EE"
            sinhButton.title = "sinh"
            setButton(coshButton, label: "cosh")
            setButton(tanhButton, label: "tanh")
            setButton(sinButton, label: "sin")
            setButton(cosButton, label: "cos")
            setButton(tanButton, label: "tan")
            intButton.title = "int"
            fracButton.title = "frac"
            divButton.title = "div"
            setButton(sqrtButton, image: NSImage(named: "sqrt"))
            setButton(cbrtButton, image: NSImage(named: "cbrt"))
            setButton(nRootButton, image: NSImage(named: "nroot"))
            setButton(log10Button, image: NSImage(named: "log10"))
            setButton(log2Button, image: NSImage(named: "log2"))
            setButton(reciprocalButton, image: NSImage(named: "inverse"))
            setButton(etoxButton, image: NSImage(named: "powerOf"))
            setButton(lnButton, image: NSImage(named: "log"))
            setButton(logyButton, image: NSImage(named: "logy"))
            setButton(asinhButton, image: NSImage(named: "asinh"))
            setButton(acoshButton, image: NSImage(named: "acosh"))
            setButton(atanhButton, image: NSImage(named: "atanh"))
            setButton(asinButton, image: NSImage(named: "asin"))
            setButton(acosButton, image: NSImage(named: "acos"))
            setButton(atanButton, image: NSImage(named: "atan"))
            reButton.title = "re"
            imButton.title = "im"
            digits += 0  // refresh digits display
        case 1: // statistic mode
            radix = 10
            enableDigits()
            setButton(aButton, label: "→rθ")
            setButton(bButton, label: ">")
            setButton(cButton, label: "<")
            setButton(dButton, label: "≥")
            setButton(percentButton, label: "%")
            setButton(pmButton, label: "⌫")
            toiButton.title = "→𝒊"
            dpButton.title = "."
            leButton.title = "≤"
            neButton.title = "≠"
            expButton.title = "EE"
            sinhButton.title = "n"
            setButton(coshButton, image: NSImage(named: "sumx"))
            setButton(tanhButton, image: NSImage(named: "sumy"))
            setButton(sinButton, image: NSImage(named: "sumx2"))
            setButton(cosButton, image: NSImage(named: "sumxy"))
            setButton(tanButton, image: NSImage(named: "sumy2"))
            intButton.title = "int"
            fracButton.title = "frac"
            divButton.title = "div"
            setButton(reciprocalButton, image: NSImage(named: "inverse"))
            setButton(etoxButton, image: NSImage(named: "powerOf"))
            setButton(sqrtButton, image: NSImage(named: "sqrt"))
            setButton(cbrtButton, image: NSImage(named: "cbrt"))
            setButton(nRootButton, image: NSImage(named: "nroot"))
            setButton(log10Button, image: NSImage(named: "stddevx"))
            setButton(log2Button, image: NSImage(named: "stddevy"))
            setButton(lnButton, image: NSImage(named: "sigmax"))
            setButton(logyButton, image: NSImage(named: "sigmay"))
            setButton(asinhButton, label: "→x")
            setButton(acoshButton, label: "→y")
            setButton(atanhButton, label: "→x,y")
            setButton(asinButton, image: NSImage(named: "xmean"))
            setButton(acosButton, image: NSImage(named: "ymean"))
            setButton(atanButton, label: "CD")
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
            setButton(coshButton, label: "or")
            setButton(tanhButton, label: "xor")
            setButton(sinButton, label: "<<")
            setButton(cosButton, label: ">>")
            setButton(tanButton, label: "gcd")
            intButton.title = "rol"
            fracButton.title = "ror"
            divButton.title = "luc"
            setButton(sqrtButton, label: "cbit")
            setButton(cbrtButton, label: "sbit")
            setButton(nRootButton, label: "tbit")
            setButton(log10Button, label: "bit")
            setButton(log2Button, label: "cnt")
            setButton(reciprocalButton, label: "odd")
            setButton(etoxButton, label: "fib")
            setButton(lnButton, label: "1’s")
            setButton(logyButton, label: "2’s")
            setButton(asinhButton, label: "nand")
            setButton(acoshButton, label: "nor")
            setButton(atanhButton, label: "xnor")
            setButton(asinButton, label: "<<1")
            setButton(acosButton, label: ">>1")
            setButton(atanButton, label: "lcm")
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
    
    func isNumber (_ button : SYFlatButton) -> Bool {
        let char = button.title
        if char == "." { return true }
        if char.characters.count == 1 {
            let ch = char.unicodeScalars.first!
            return CharacterSet.decimalDigits.contains(ch)
        }
        return false
    }
    
    @IBAction func keypadChanged(_ sender: NSSegmentedControl) {
        keypad = sender.integerValue
        setKeypadLabels(sender.integerValue)
    }
    
    func addToEquation(_ s: String) {
        if equation.hasPrefix("&emsp;") { equation = "" }  // remove placeholder
        equation += s
    }
    
    @IBAction func keyPressed(_ sender: SYFlatButton) {
        addToEquation(sender.title)
        if !isNumber(sender) { addToEquation(" ") }
        updateDisplay()
    }
    
    let mfuncs = [
        "", "^2", "^3", "^", "10^", "2^", "e^", "^(-1)",            // row 3
        "sinh", "cosh", "tanh", "sin", "cos", "tan", "/",           // row 4
        "asinh", "acosh", "atanh", "asin", "acos", "atan", "rand",  // row 5
        "abs", "re", "im", "int", "frac", "div", "cmplx", "rtheta", // row 6
        "sqrt", "cbrt", "nroot", "log10", "log2", "ln", "logy",     // row 2
        "!"                                                         // row 1
    ]
    
    let pfuncs = [
        "", "^2", "^3", "^", "10^", "2^", "fib", "odd",             // row 3
        "and", "or", "xor", "<<", ">>", "gcd", "/",                 // row 4
        "nand", "nor", "xnor", "<<1", ">>1", "lcm", "rand",         // row 5
        "abs", "bits", "bytes", "rol", "ror", "luc", "mod", "A",    // row 6
        "cbit", "sbit", "tbit", "bit", "cnt", "compl", "neg",       // row 2
        "!"                                                         // row 1
    ]
    
    @IBAction func funcPressed(_ sender: SYFlatButton) {
        let id = sender.tag
        if id <= 0 || id >= mfuncs.count { return } // tags are all > 0
        if keypad == 0 { addToEquation(mfuncs[id]) }
        else if keypad == 2 { addToEquation(pfuncs[id]) }
        updateDisplay()
    }

    @IBAction func clearPressed(_ sender: Any) {
        equation = "&emsp;"
        result = "0"
        updateDisplay()
    }
    
    @IBAction func equalPressed(_ sender: SYFlatButton) {
        let input = InputStream(data: equation.data(using: .utf8)!)
        let scanner = Scanner(s: input)
        let parser = Parser(scanner: scanner)
        parser.Parse()
        if parser.errors.count == 0 {
            print("Value = \(parser.curBlock.value)")
            result = String(parser.curBlock.value)
        } else {
            result = "\(parser.errors.count) errors"
        }
        updateDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearPressed(iButton)  // dummy button argument
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
                self.addToEquation(key)
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
                self.addToEquation(prefix)
                self.updateDisplay()
            }
        } else if segue.identifier == "Show Constants" {
            let vc = segue.destinationController as! ConstController
            vc.callback = { const in
                var const = const
                if const.contains("_") {
                    const = const.replacingOccurrences(of: "_", with: "<sub>") + "</sub>"
                }
                self.addToEquation(const)
                self.updateDisplay()
            }
        }
    }
    
    

}


