//
//  MathML.swift
//  MakeMathML
//
//  Created by Mike Griebling on 13 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Foundation

extension Node {
    
    // mathml/latex constructors
    
    func symbol(_ x: String, latex: Bool = true, size: Int = 0) -> String {
        if latex {
            return x
        } else {
            let s = size == 0 ? "" : " mathsize=\"\(size)\""
            return "<mo\(s)>\(x)</mo>\n"
        }
    }
    
    func variable(_ x: String, latex: Bool = true, size: Int = 0) -> String {
        if latex {
            return "\\" + x
        } else {
            let s = size == 0 ? "" : " mathsize=\"\(size)\""
            return "<mi\(s)>\(x)</mi>\n"
        }
    }
    
    func number(_ val: Double, latex: Bool = true, size: Int = 0) -> String {
        var v = String(val)
        if v.hasSuffix(".0") { v = v.replacingOccurrences(of: ".0", with: "") }
        if latex {
            return v
        } else {
            let s = size == 0 ? "" : " mathsize=\"\(size)\""
            return "<mn\(s)>\(v)</mn>\n"
        }
    }
    
    func power(_ x: String, to y: String, latex: Bool = true) -> String {
        if latex {
            return "{\(x)}^{\(y)}"
        } else {
            return "<msup>\n\(x)\(y)</msup>\n"
        }
    }
    
    func fraction(_ x: String, over y: String, latex: Bool = true) -> String {
        if latex {
            return "\\frac{\(x)}{\(y)}"
        } else {
            return "<mfrac>\n\(x)\(y)</mfrac>\n"
        }
    }
    
    func root(_ x: String, n: Int, latex: Bool = true) -> String {
        if latex {
            var x = x
            if x == "sqrt" { x = "" }
            if n == 2 {
                return "\\sqrt{\(x)}"
            } else {
                return "\\sqrt[\(n)]{\(x)}"
            }
        } else {
            if n == 2 {
                return "<msqrt>\n\(x)</msqrt>\n"
            } else {
                return "<mroot><mrow>\n\(x)</mrow>\n\(number(Double(n)))</mroot>\n"
            }
        }
    }
    
    func isComplex(_ x: String, latex: Bool = true) -> Bool {
        if latex {
            return x.contains("\\frac") || x.contains("\\sqrt") || x.contains("^")
        } else {
            return x.contains("<mfrac>") || x.contains("<msup>") || x.contains("<msqrt>") || x.contains("<mroot>") ||
                x.contains("<mrow>")
        }
    }
    
    func fenced(_ x: String, open: String = "(", close: String = ")", latex: Bool = true) -> String {
        var braces = ""
        if latex {
            if isComplex(x) {
                return "\\left\(open)\(x)\\right\(close)"
            } else {
                return open + x + close + "\n"
            }
        } else {
            if isComplex(x, latex: latex) {
                if open != "(" || close != ")" {
                    braces = " open=\"\(open)\" close=\"\(close)\""
                }
                return "<mfenced\(braces)>\n<mrow>\(x)</mrow></mfenced>\n"
            } else {
                return symbol(open) + x + symbol(close) + "\n"
            }
        }
    }
    
}

public class MathML {
    
    var presentation: String = ""
    var semantic: String = ""
    
    public init(_ equation: String) {
        
    }
    
    
}
