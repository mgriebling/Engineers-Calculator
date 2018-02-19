//
//  AST.swift
//  MakeMathML
//
//  Created by Mike Griebling on 13 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Foundation

public enum Type { case UNDEF, INT, BOOL }
public enum Operator { case EQU, LSS, GTR, GEQ, LEQ, NEQ, ADD, SUB, MUL, DIV, REM, OR, AND, NOT, POW, ROOT, LOG, FACT, SQR, CUB }

/// Base node class of the AST
public class Node {
    public init() {}
    public func dump() {}
    func printn(_ s: String) { print(s, terminator: "") }
    public var value: CDecimal { return 0 }
    public var mathml: String { return "" }
    public var latex: String { return "" }
}


//----------- Declarations ----------------------------

public class Obj : Node {      // any declared object that has a name
    var name: String    // name of this object
    var type: Type      // type of the object (UNDEF for procedures)
    var val: Expr?
    init(_ s: String, _ t: Type) { name = s; type = t }
}

public class Var : Obj {       // variables
    var adr: Int = 0    // address in memory
    override init(_ name: String, _ type: Type) { super.init(name, type) }
}

public class BuiltInProc : Expr {
    
    static func log2 (_ x : CDecimal) -> CDecimal { return CDecimal.ln(x) / CDecimal.ln(CDecimal(Decimal.two)) }
    static func abs (_ x : CDecimal) -> CDecimal { return CDecimal(CDecimal.abs(x)) }
    
    static var _builtIns : [String: (_:CDecimal) -> CDecimal] = [
        "sin"  : CDecimal.sin,
        "cos"  : CDecimal.cos,
        "tan"  : CDecimal.tan,
        "asin" : CDecimal.asin,
        "acos" : CDecimal.acos,
        "atan" : CDecimal.atan,
        "sinh" : CDecimal.sinh,
        "cosh" : CDecimal.cosh,
        "tanh" : CDecimal.tanh,
        "asinh": CDecimal.asinh,
        "acosh": CDecimal.acosh,
        "atanh": CDecimal.atanh,
        "exp"  : CDecimal.exp,
        "ln"   : CDecimal.ln,
        "log"  : CDecimal.log10,
        "log10": CDecimal.log10,
        "log2" : log2,
        "abs"  : abs,
        "sqrt" : CDecimal.sqrt,
        "cbrt" : CDecimal.cbrt
    ]
    
    var op: (_:CDecimal) -> CDecimal
    var arg: Expr?
    var name: String
    
    init(_ name: String, _ arg: Expr?) { op = BuiltInProc._builtIns[name] ?? { _ in 0 }; self.name = name; self.arg = arg; super.init() }
    override public func dump() { printn("Built-in " + name + "("); arg?.dump(); printn(")") }
    override public var value: CDecimal { return op(arg?.value ?? 0) }
    
    override public var mathml: String {
        let x = arg?.mathml ?? ""
        var s = ""
        switch name {
        case "sqrt": return root(x, n: 2, latex: false)
        case "cbrt": return root(x, n: 3, latex: false)
        case "abs": return  fenced(x, open: "|", close: "|", latex: false)
        case "exp": return power(variable("e"), to: x, latex: false)
        case "log", "log10": s += "<msub>\n\(variable("log"))\(number(10, latex: false))</msub>\n"
        case "log2": s += "<msub>\n\(variable("log"))\(number(2, latex: false))</msub>\n"
        case "asin", "acos", "atan", "asinh", "acosh", "atanh":
            var f = name
            let _ = f.remove(at: f.startIndex)
            s = power(variable(f), to: number(-1), latex: false)
        default: s += variable(name, latex: false)
        }
        return s + fenced(x, latex: false)
    }
    
    override public var latex: String {
        let x = arg?.latex ?? ""
        var s = ""
        switch name {
        case "sqrt": return root(x, n: 2)
        case "cbrt": return root(x, n: 3)
        case "abs": return fenced(x, open: "|", close: "|")
        case "exp": return power(variable("e"), to: x)
        case "log", "log10": s += "\\log_{10}"
        case "log2": s += "\\log_{2}"
        case "asin", "acos", "atan", "asinh", "acosh", "atanh":
            var f = name
            let _ = f.remove(at: f.startIndex)
            s = power(variable(f), to: number(-1))
        default: s += variable(name)
        }
        return s + fenced(x)
    }
}

public class Proc : Obj {      // procedure (also used for the main program)
    var locals: [Obj]   // local objects declared in this procedure
    var block: Block?   // block of this procedure (nil for the main program)
    var nextAdr = 0     // next free address in this procedure
    var program: Proc?  // link to the Proc node of the main program or nil
    var parser: Parser  // for error messages
    
   	init (_ name: String, _ program: Proc?, _ parser: Parser) {
        locals = [Obj]()
        self.program = program
        self.parser = parser
        super.init(name, .UNDEF)
    }
    
    func add (_ obj: Obj) {
        for o in locals {
            if o.name == obj.name { parser.SemErr(obj.name + " declared twice") }
        }
        locals.append(obj)
        if obj is Var { (obj as! Var).adr = nextAdr; nextAdr += 1 }
    }
    
    func find (_ name: String) -> Obj {
        for o in locals { if o.name == name { return o } }
        if program != nil { for o in program!.locals { if o.name == name { return o } } }
        let o = Obj(name, .INT) // declare a default name
        add(o)
        return o
    }
    
    override public var value: CDecimal {
        return block?.value ?? 0
    }
    
    override public func dump() {
        print("Proc " + name); block?.dump(); print()
    }
    
    override public var mathml: String {
        return block?.mathml ?? ""
    }
    
    override public var latex: String {
        return block?.latex ?? ""
    }
}

//----------- Expressions ----------------------------

public class Expr : Node {}

public class BinExpr: Expr {
    var op: Operator
    var left, right: Expr?
    
    public init(_ e1: Expr?, _ o: Operator, _ e2: Expr?) { op = o; left = e1; right = e2 }
    public override func dump() { printn("("); left?.dump(); printn(" \(op) "); right?.dump(); printn(")") }
    
    public override var value: CDecimal {
        let l = left?.value ?? 0
        let r = right?.value ?? 0
        switch op {
        case .ADD: return l + r
        case .SUB: return l - r
        case .MUL: return l * r
        case .DIV: return l / r
        case .REM: return CDecimal(l.abs % r.abs)
        case .AND: return CDecimal(l.abs & r.abs)
        case .OR:  return CDecimal(l.abs | r.abs)
        case .POW: return CDecimal.pow(l, r)
        case .ROOT: return CDecimal.pow(r, Decimal(1.0/Double(l.abs.int)))
        case .LOG: return CDecimal.ln(r)/CDecimal.ln(l)
        case .EQU: return l == r ? 1 : 0
        case .LSS: return l.abs < r.abs ? 1 : 0
        case .GTR: return l.abs > r.abs ? 1 : 0
        case .LEQ: return l.abs <= r.abs ? 1 : 0
        case .GEQ: return l.abs >= r.abs ? 1 : 0
        case .NEQ: return l != r ? 1 : 0
        default: return 0  // shouldn't occur
        }
    }
    
    override public var mathml: String {
        var s = ""
        let l = left?.mathml ?? ""
        let r = right?.mathml ?? ""
        switch op {
        case .ADD: s = symbol("+", latex: false)
        case .SUB: s = symbol("&minus;", latex: false)
        case .MUL: s = symbol("&InvisibleTimes;", latex: false)
        case .DIV: return fraction(l, over: r, latex: false)
        case .REM: s = symbol("%", latex: false)
        case .AND: s = symbol("&amp;", latex: false)
        case .OR:  s = symbol("|", latex: false)
        case .POW: return power(l, to:r, latex: false)
        case .ROOT: return root(r, n: left?.value.abs.int ?? 2, latex: false)
        case .LOG: return "<msub>\n\(variable("log"))\(number(CDecimal(Decimal(left?.value.abs.int ?? 10)), latex: false))</msub>\n" + r
        case .EQU: s = symbol("=", latex: false)
        case .LSS: s = symbol("&lt;", latex: false)
        case .GTR: s = symbol("&gt;", latex: false)
        case .LEQ: s = symbol("&le;", latex: false)
        case .GEQ: s = symbol("&ge;", latex: false)
        case .NEQ: s = symbol("&ne;", latex: false)
        default: break
        }
        return l + s + r
    }
    
    override public var latex: String {
        var s = ""
        let l = left?.latex ?? ""
        let r = right?.latex ?? ""
        switch op {
        case .ADD: s = symbol("+")
        case .SUB: s = symbol("-")
        case .MUL: s = symbol("\\times")
        case .DIV: return fraction(l, over: r)
        case .REM: s = symbol("\\%")
        case .AND: s = symbol("\\&")
        case .OR:  s = symbol("\\textbar")
        case .POW: return power(l, to:r)
        case .ROOT: return root(r, n: left?.value.abs.int ?? 2)
        case .LOG: return "\\log_\(left?.value.abs.int ?? 10)" + r
        case .EQU: s = symbol("=")
        case .LSS: s = symbol("<")
        case .GTR: s = symbol(">")
        case .LEQ: s = symbol("\\leq")
        case .GEQ: s = symbol("\\geq")
        case .NEQ: s = symbol("\\neq")
        default: break
        }
        return l + s + r
    }
}

public class UnaryExpr: Expr {
    var op: Operator
    var e: Expr?
    
    public init(_ x: Operator, _ y: Expr?) { op = x; e = y }
    public override func dump() { printn("\(op) "); e?.dump() }
    
    public override var value: CDecimal {
        let x = e?.value ?? 0
        switch op {
        case .SUB: return -x
        case .NOT: return CDecimal(~x.abs)
        case .SQR: return x*x
        case .CUB: return x*x*x
        case .FACT: return CDecimal(x.abs.factorial())
        default: return x
        }
    }
    
    override public var mathml: String {
        let x = e?.mathml ?? ""
        var s = ""
        switch op {
        case .SUB: s = symbol("-", latex: false)
        case .NOT: return "<mover>\n<mrow>\n\(x)</mrow>\n" + symbol("&OverBar;", latex: false) + "</mover>\n"
        case .SQR: return power(x, to:number(2), latex: false)
        case .CUB: return power(x, to:number(3), latex: false)
        case .FACT: return x + symbol("!", latex: false)
        default: break
        }
        return s + x
    }
    
    override public var latex: String {
        let x = e?.latex ?? ""
        var s = ""
        switch op {
        case .SUB: s = symbol("-")
        case .NOT: return "\\overline{\(x)}"
        case .SQR: return power(x, to:number(2))
        case .CUB: return power(x, to:number(3))
        case .FACT: return x + symbol("!")
        default: break
        }
        return s + x
    }
}

public class Ident: Expr {
    var obj: Obj
    
    static var _symbols : [String: CDecimal] = [
        "π"  : CDecimal(Decimal.pi),
        "e"  : CDecimal(Decimal.one.exp())
    ]

    init(_ o: Obj) { obj = o }
    override public func dump() { printn(obj.name) }
    override public var value: CDecimal {
        if let x = Ident._symbols[obj.name] { return x }
        return obj.val?.value ?? 0
    }
    override public var mathml: String {
        if obj.name == "π" { return variable("&pi;", latex: false) }
        return variable(obj.name, latex: false)
    }
    override public var latex: String {
        if obj.name == "π" { return variable("\\pi") }
        if let latex = Constant.values[obj.name] {
            if latex.latex.isEmpty {
                return symbol(obj.name)
            } else {
                return latex.latex
            }
        }
        return variable(obj.name)
    }
}

public class IntCon: Expr {
    var val: CDecimal
    
    init(_ x: CDecimal) { val = x }
    override public func dump() { printn("\(val)") }
    override public var value: CDecimal { return val }
    override public var mathml: String { return number(val, latex: false) }
    override public var latex: String { return number(val) }
}

public class BoolCon: Expr {
    var val: Bool
    
    init(_ x: Bool) { val = x }
    override public func dump() { printn("\(val)") }
    override public var value: CDecimal { return val ? 1 : 0 }
    override public var mathml: String { return symbol("\(val)", latex: false) }
    override public var latex: String { return symbol("\(val)") }
}

//------------- Statements -----------------------------

public class Stat: Node {
    static var indent = 0
    override public func dump() { for _ in 0..<Stat.indent { printn("  ") } }
}

public class Assignment: Stat {
    var left: Obj?
    var right: Expr?
    
    init(_ o:Obj?, _ e:Expr?) { left = o; left?.val = e; right = e }
    override public func dump() { super.dump(); if left != nil { printn(left!.name + " = ") }; right?.dump() }
    override public var value: CDecimal { return right?.value ?? 0 }
    
    override public var mathml: String {
        let e = right?.mathml ?? ""
        let l = left?.name ?? ""
        var x = "<mrow>\n"
        if !l.isEmpty {
            x += variable(l, latex: false) + symbol("=", latex: false)
        }
        return x + e + "</mrow>\n"
    }
    
    override public var latex: String {
        let e = right?.latex ?? ""
        let l = left?.name ?? ""
        var x = ""
        if !l.isEmpty {
            x += variable(l) + symbol("=")
        }
        return x + e
    }
}

public class Block: Stat {
    var stats = [Stat]()
    
    func add(_ s: Stat?) { if s != nil { stats.append(s!) } }
    
    override public func dump() {
        super.dump()
        print("Block("); Stat.indent+=1
        for s in stats { s.dump(); print("  => \(s.value)") }
        Stat.indent-=1; super.dump(); print(")")
    }
    
    override public var value: CDecimal {
        return stats.last?.value ?? 0
    }
    
    override public var mathml: String {
        var r = "<!DOCTYPE html>\n<html>\n<body>\n"
        for s in stats { r += "<p><math>\n" + s.mathml + "</math></p>\n\n" }
        return r + "</html>\n</body>\n"
    }
    
    override public var latex: String {
        var r = ""
        for s in stats { r += s.latex + "\n" }
        return r
    }
}

