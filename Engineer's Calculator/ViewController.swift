//
//  ViewController.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 20 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Cocoa
import iosMath

class ViewController: NSViewController {
    
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
    
    let empty = ""
    
    enum Keypad : Int { case normal=0, statistic=1, programming=2 }
    
    var equation = ""
    var result = ""
    var latex = ""
    var keypad = Keypad.normal
    
    var radix = 10
    var bits = 32 { didSet { digitsDisplay.setLabel("Bits: \(bits)", forSegment: 0) } }
    var digits = 25 {didSet { digitsDisplay.setLabel("Digits: \(digits)", forSegment: 0) } }
    
    // MARK: - Support utility methods

    @IBOutlet weak var mathView: MTMathUILabel!

    @IBAction func radixChanged(_ sender: NSSegmentedControl) {
        if keypad == .programming { setFFButton() }
        switch sender.integerValue {
        case 0: radix = 2
        case 1: radix = 8
        case 3: radix = 16
        default: radix = 10
        }
        enableDigits()
    }
    
    func updateDisplay() {
        //        let content = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><title>Equation #1</title>" +
        //        "</head><body text=\"white\"><font face=\"Helvetica Neue\" size=\"6\">\(equation)<font face=\"Helvetica Neue\" size=\"2\">" +
        //        "<p align=\"right\"><font face=\"Helvetica Neue\" size=\"5\">\(result) &emsp;</p></body></html>"
        mathView.latex = latex
        //        webView.loadHTMLString(eqation, baseURL: nil)
    }
    
    func isNumber (_ button : SYFlatButton) -> Bool {
        let char = button.title
        let chSet = CharacterSet(charactersIn: ".+−ABCDEF").union(CharacterSet.decimalDigits)
        if char == "EE" { return true }
        if char.count == 1 {
            let ch = char.unicodeScalars.first!
            return chSet.contains(ch)
        }
        return false
    }
    
    @IBAction func keypadChanged(_ sender: NSSegmentedControl) {
        keypad = Keypad(rawValue: sender.integerValue)!
        setKeypadLabels(keypad)
    }
    
    func addToEquation(_ s: String) {
        equation += s
    }
    
    
    // MARK: - Calculator function handling
    
    let mfuncs = [
        "", "^2", "^3", "^", "10^", "2^", "e^", "^(-1)",            // row 3
        "sinh", "cosh", "tanh", "sin", "cos", "tan", "/",           // row 4
        "asinh", "acosh", "atanh", "asin", "acos", "atan", "rand",  // row 5
        "abs", "re", "im", "int", "frac", "div", "cmplx", "rtheta", // row 6
        "sqrt(", "cbrt", "nroot", "log10", "log2", "ln", "logy",     // row 2
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
        switch keypad {
        case .normal: addToEquation(mfuncs[id])
        case .programming: addToEquation(pfuncs[id])
        case .statistic: break // TBD
        }
        parseInput()
        updateDisplay()
    }
    
    @IBAction func keyPressed(_ sender: SYFlatButton) {
        let key = sender.title
        if key == "EE" { addToEquation("e") }
        else { addToEquation(key) }
        if !isNumber(sender) { addToEquation(" ") }
        parseInput()
        updateDisplay()
    }

    @IBAction func clearPressed(_ sender: Any) {
        equation = empty
        result = "0"
        latex = ""
        updateDisplay()
    }
    
    @IBAction func backSpace(_ sender: SYFlatButton) {
        if equation == empty { return }
        _ = equation.remove(at: equation.index(before: equation.endIndex))
        if equation.isEmpty { equation = empty }
        parseInput()
        updateDisplay()
    }
    
    private func parseInput(_ showResult: Bool = false) {
        let input = InputStream(data: equation.data(using: .utf8)!)
        let scanner = Scanner(s: input)
        let parser = Parser(scanner: scanner)
        parser.Parse()
        if showResult {
            if parser.errors.count == 0 {
                print("Value = \(parser.curBlock.value)")
                print("Latex = \(parser.curBlock.latex)")
                result = String(parser.curBlock.value)
            } else {
                result = "\(parser.errors.count) errors"
            }
        } else {
            latex = parser.curBlock.latex
        }
    }
    
    @IBAction func equalPressed(_ sender: SYFlatButton) {
        parseInput(true)
        updateDisplay()
    }
    
	// MARK: - Viewcontroller life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clearPressed(iButton)  // dummy button argument
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        if identifier.rawValue == "Show Radix" && keypad != .programming {
            return false
        }
        return true
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier!.rawValue {
        case "Show LetterPad":
            let vc = segue.destinationController as! LetterPadController
            vc.keyPressed = { key in
                self.addToEquation(key)
                self.updateDisplay()
            }
        case "Show Digits":
            let vc = segue.destinationController as! DigitController
            if keypad != .programming {
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
        case "Show Radix":
            let vc = segue.destinationController as! RadixController
            vc.callback = { prefix in
                self.addToEquation(prefix)
                self.updateDisplay()
            }
        case "Show Constants":
            let vc = segue.destinationController as! ConstController
            vc.callback = { const in
//                var const = const
//                if const.contains("_") {
//                    const = const.replacingOccurrences(of: "_", with: "<sub>") + "</sub>"
//                }
                self.addToEquation(const)
                self.updateDisplay()
            }
        default: break
        }
    }

}

extension ViewController {
    
	// MARK: - Keypad label management
    
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
    
    func setKeypadLabels(_ mode: Keypad) {
        radixControl.isEnabled = false
        degRadGradControl.isEnabled = true
        numberModeControl.isEnabled = true
        switch mode {
        case .normal: // mode
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
            setButton(sqrtButton, image: NSImage(named: NSImage.Name(rawValue: "sqrt")))
            setButton(cbrtButton, image: NSImage(named: NSImage.Name(rawValue: "cbrt")))
            setButton(nRootButton, image: NSImage(named: NSImage.Name(rawValue: "nroot")))
            setButton(log10Button, image: NSImage(named: NSImage.Name(rawValue: "log10")))
            setButton(log2Button, image: NSImage(named: NSImage.Name(rawValue: "log2")))
            setButton(reciprocalButton, image: NSImage(named: NSImage.Name(rawValue: "inverse")))
            setButton(etoxButton, image: NSImage(named: NSImage.Name(rawValue: "powerOf")))
            setButton(lnButton, image: NSImage(named: NSImage.Name(rawValue: "log")))
            setButton(logyButton, image: NSImage(named: NSImage.Name(rawValue: "logy")))
            setButton(asinhButton, image: NSImage(named: NSImage.Name(rawValue: "asinh")))
            setButton(acoshButton, image: NSImage(named: NSImage.Name(rawValue: "acosh")))
            setButton(atanhButton, image: NSImage(named: NSImage.Name(rawValue: "atanh")))
            setButton(asinButton, image: NSImage(named: NSImage.Name(rawValue: "asin")))
            setButton(acosButton, image: NSImage(named: NSImage.Name(rawValue: "acos")))
            setButton(atanButton, image: NSImage(named: NSImage.Name(rawValue: "atan")))
            reButton.title = "re"
            imButton.title = "im"
            digits += 0  // refresh digits display
        case .statistic: // mode
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
            setButton(coshButton, image: NSImage(named: NSImage.Name(rawValue: "sumx")))
            setButton(tanhButton, image: NSImage(named: NSImage.Name(rawValue: "sumy")))
            setButton(sinButton, image: NSImage(named: NSImage.Name(rawValue: "sumx2")))
            setButton(cosButton, image: NSImage(named: NSImage.Name(rawValue: "sumxy")))
            setButton(tanButton, image: NSImage(named: NSImage.Name(rawValue: "sumy2")))
            intButton.title = "int"
            fracButton.title = "frac"
            divButton.title = "div"
            setButton(reciprocalButton, image: NSImage(named: NSImage.Name(rawValue: "inverse")))
            setButton(etoxButton, image: NSImage(named: NSImage.Name(rawValue: "powerOf")))
            setButton(sqrtButton, image: NSImage(named: NSImage.Name(rawValue: "sqrt")))
            setButton(cbrtButton, image: NSImage(named: NSImage.Name(rawValue: "cbrt")))
            setButton(nRootButton, image: NSImage(named: NSImage.Name(rawValue: "nroot")))
            setButton(log10Button, image: NSImage(named: NSImage.Name(rawValue: "stddevx")))
            setButton(log2Button, image: NSImage(named: NSImage.Name(rawValue: "stddevy")))
            setButton(lnButton, image: NSImage(named: NSImage.Name(rawValue: "sigmax")))
            setButton(logyButton, image: NSImage(named: NSImage.Name(rawValue: "sigmay")))
            setButton(asinhButton, label: "→x")
            setButton(acoshButton, label: "→y")
            setButton(atanhButton, label: "→x,y")
            setButton(asinButton, image: NSImage(named: NSImage.Name(rawValue: "xmean")))
            setButton(acosButton, image: NSImage(named: NSImage.Name(rawValue: "ymean")))
            setButton(atanButton, label: "CD")
            reButton.title = "nPr"
            imButton.title = "nCr"
        case .programming: // mode
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
    
    
}


