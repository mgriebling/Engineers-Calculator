//
//  Constants.swift
//  Engineer's Calculator
//
//  Created by Mike Griebling on 26 Aug 2017.
//  Copyright © 2017 Computer Inspirations. All rights reserved.
//

import Foundation

// Constants last updated from NIST 2014 values

class Constant {
    
    struct Description {
        let value: String
        let description: String
        let latex: String
        
        init(_ v: String, _ d: String, _ l: String = "") {
            value = v
            description = d
            latex = l
        }
    }
    
    static func getFormattedStringFor(_ c: String) -> NSAttributedString {
        let cv = c.components(separatedBy: "_")
        if cv.count == 1 {
            return NSAttributedString(string: c)
        } else {
            var location = (c as NSString).range(of: "_")
            let result = NSMutableAttributedString(string: c.replacingOccurrences(of: "_", with: ""))
            location.length = cv[1].count
            result.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 13), range: location)
            result.addAttribute(NSAttributedStringKey.superscript, value: -1, range: location)
            return result
        }
    }
    
    static let sorted = values.sorted { (left, right) -> Bool in
        if left.key == "π"  { return true }
        if right.key == "π" { return false }
        if left.key == "i"  { return true }
        if right.key == "i"  { return false }
        return left.key < right.key
    }
    
    static func evalString(_ s: String) -> Double {
        let input = InputStream(data: s.data(using: .utf8)!)
        let scanner = Scanner(s: input)
        let parser = Parser(scanner: scanner)
        parser.Parse()
        if parser.errors.count == 0 {
            return parser.curBlock.value
        } else {
            return 0
        }
    }
    
    static func addConstantsToIdents () {
        for symbol in values {
            // Test for predefined symbols
            if symbol.key != "π" && symbol.key != "i" {
                let x = symbol.value.value
                let n = evalString(x)
                Ident._symbols[symbol.key] = n
                print("Adding symbol " + symbol.key + " = \(n)")
            }
        }
        print(Ident._symbols)
    }
    
    static let values : [String: Description] = [
        "π":    Description("π",                    "Pi",                                       "\\pi"),
        "i":    Description("i",                    "Square-root of -1",                        "\\imath"),
        "a_0":  Description("0.529_177_210_67e-10", "Bohr radius (m)"),
        "α":    Description("7.297_352_5664e-3",    "Fine structure constant",                  "\\alpha_0"),
        "atm":  Description("101_325",              "Standard atmosphere (Pa)"),
        "b":    Description("2.897_7729e-3",        "Wien displacement law constant (m K)"),
        "c_1":  Description("3.741_771_790e-16",    "First radiation constant (W m²)"),
        "c_2":  Description("1.438_777_36e-2",      "Second radiation constant (m K)"),
        "c":    Description("299_792_458",          "Speed of light in vacuum (m s⁻¹)"),
        "E_h":  Description("4.359_744_650e-18",    "Hartree energy (J)"),
        "e_c":  Description("1.602_176_6208e-19",   "Elementary charge (C)"),
        "ε_0":  Description("1/(μ_0*c^2)",          "Electric constant 1/μ₀c² (F m⁻¹)",         "\\varepsilon_0"),
        "eV":   Description("1.602_176_6208e-19",   "Electron volt (J)"),
        "F":    Description("96_485.332_89",        "Faraday constant (C mol⁻¹)"),
        "g_e":  Description("-2.002_319_304_361_82", "Electron g-factor"),
        "g_µ":  Description("-2.002_331_8418",      "Muon g-factor",                            "g_\\mu"),
        "g_n":  Description("9.806_65",             "Standard acceleration of gravity (m s⁻²)"),
        "G":    Description("6.674_08e-11",         "Gravitational constant (m³ kg⁻¹ s⁻²)"),
        "G_0":  Description("7.748_091_7310e-5",    "Conductance quantum (S)"),
        "h":    Description("6.626_070_040e-34",    "Planck constant (J s)"),
        "ħ":    Description("1.054_571_800e-34",    "Planck constant/2π (J s)",                 "\\hbar"),
        "k":    Description("1.380_648_52e-23",     "Boltzmann constant (J K⁻¹)"),
        "l_P":  Description("1.616_229e−35",        "Planck length (m)"),
        "ƛ_C":  Description("386.159_267_64e-15",   "Electron Compton wavelength/2π (m)",       "\\textcrlambda_C"),
        "λ_Cn": Description("1.319_590_904_81e-15", "Neutron Compton wavelength (m)",           "\\lambda_Cn"),
        "λ_Cp": Description("1.321_409_853_96e-15", "Proton Compton wavelength (m)",            "\\lambda_Cp"),
        "λ_C":  Description("2.426_310_2367e-12",   "Electron Compton wavelength (m)",          "\\lambda_C"),
        "m_d":  Description("3.343_583_719e-27",    "Deuteron mass (kg)"),
        "m_e":  Description("9.109_383_56e-31",     "Electron mass (kg)"),
        "m_n":  Description("1.674_927_471e-27",    "Neutron mass (kg)"),
        "m_P":  Description("2.176_470e-8",         "Planck mass (kg)"),
        "m_p":  Description("1.672_621_898e-27",    "Proton mass (kg)"),
        "m_u":  Description("1.660_539_040e-27",    "Atomic mass constant (kg)"),
        "µ_0":  Description("4*π*1e-7",             "Magnetic constant (N A⁻²)",                "\\mu_0"),
        "µ_B":  Description("927.400_9994e-26",     "Bohr magneton (J T⁻¹)",                    "\\mu_B"),
        "µ_d":  Description("0.433_073_5040e-26",   "Deuteron magnetic moment (J T⁻¹)",         "\\mu_d"),
        "µ_N":  Description("5.050_783_699e-27",    "Nuclear magneton (J T⁻¹)",                 "\\mu_N"),
        "n_0":  Description("2.651_6467e25",        "Loschmidt constant (m⁻³)"),
        "N_A":  Description("6.022_140_857e23",     "Avagadro constant (mol⁻¹)"),
        "φ_0":  Description("2.067_833_831e-15",    "Magnetic flux quantum (Wb)",               "\\phi_0"),
        "r_e":  Description("2.817_940_3227e-15",   "Electron classical radius (m)"),
        "R_K":  Description("25_812.807_4555",      "von Klitzing constant (Ω)"),
        "R":    Description("8.314_4598",           "Molar gas constant (J mol⁻¹ K⁻¹)"),
        "R_∞":  Description("10_973_731.568_508",   "Rydberg constant (m⁻¹)",                   "R_\\infty"),
        "σ_e":  Description("0.665_245_871_58e-28", "Electron Thomson cross section (m²)",      "\\sigma_e"),
        "σ":    Description("5.670_367e-8",         "Stefan-Boltzmann const. (W m⁻² K⁻⁴)",      "\\sigma "),
        "t_p":  Description("5.391_16e-44",         "Planck time (s)"),
        "T_P":  Description("1.416_808e32",         "Planck temperature (K)"),
        "V_m":  Description("22.710_947e-3",        "Molar vol. (ideal gas at STP) (m³ mol⁻¹)")
    ]
  
}
