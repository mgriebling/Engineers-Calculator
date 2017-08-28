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
        
        init(_ v: String, _ d: String) {
            value = v
            description = d
        }
    }
    
    static func getFormattedStringFor(_ c: String) -> NSAttributedString {
        let cv = c.components(separatedBy: "_")
        if cv.count == 1 {
            return NSAttributedString(string: c)
        } else {
            var location = (c as NSString).range(of: "_")
            let result = NSMutableAttributedString(string: c.replacingOccurrences(of: "_", with: ""))
            location.length = cv[1].characters.count
            result.addAttribute(NSFontAttributeName, value: NSFont.systemFont(ofSize: 13), range: location)
            result.addAttribute(NSSuperscriptAttributeName, value: -1, range: location)
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
    
    static let values : [String: Description] = [
        "π":    Description("π",                    "Pi"),
        "i":    Description("i",                    "Square-root of -1"),
        "a_0":  Description("0.529_177_210_67E-10", "Bohr radius (m)"),
        "α":    Description("7.297_352_5664E-3",    "Fine structure constant"),
        "atm":  Description("101_325",              "Standard atmosphere (Pa)"),
        "b":    Description("2.897_7729E−3",        "Wien displacement law constant (m K)"),
        "c_1":  Description("3.741_771_790E−16",    "First radiation constant (W m²)"),
        "c_2":  Description("1.438_777_36E−2",      "Second radiation constant (m K)"),
        "c":    Description("299_792_458",          "Speed of light in vacuum (m s⁻¹)"),
        "E_h":  Description("4.359_744_650E−18",    "Hartree energy (J)"),
        "e_c":  Description("1.602_176_6208E−19",   "Elementary charge (C)"),
        "ε_0":  Description("1/(μ_0*c^2)",          "Electric constant 1/μ₀c² (F m⁻¹)"),
        "eV":   Description("1.602_176_6208E-19",   "Electron volt (J)"),
        "F":    Description("96_485.332_89",        "Faraday constant (C mol⁻¹)"),
        "g_e":  Description("−2.002_319_304_361_82", "Electron g-factor"),
        "g_µ":  Description("−2.002_331_8418",      "Muon g-factor"),
        "g_n":  Description("9.806_65",             "Standard acceleration of gravity (m s⁻²)"),
        "G":    Description("6.674_08E-11",         "Gravitational constant (m³ kg⁻¹ s⁻²)"),
        "G_0":  Description("7.748_091_7310E-5",    "Conductance quantum (S)"),
        "h":    Description("6.626_070_040E−34",    "Planck constant (J s)"),
        "ħ":    Description("1.054_571_800E−34",    "Planck constant/2π (J s)"),
        "k":    Description("1.380_648_52E−23",     "Boltzmann constant (J K⁻¹)"),
        "l_P":  Description("1.616_229E−35",        "Planck length (m)"),
        "ƛ_C":  Description("386.159_267_64E−15",   "Electron Compton wavelength/2π (m)"),
        "λ_Cn": Description("1.319_590_904_81E−15", "Neutron Compton wavelength (m)"),
        "λ_Cp": Description("1.321_409_853_96E−15", "Proton Compton wavelength (m)"),
        "λ_C":  Description("2.426_310_2367E−12",   "Electron Compton wavelength (m)"),
        "m_d":  Description("3.343_583_719E−27",    "Deuteron mass (kg)"),
        "m_e":  Description("9.109_383_56E−31",     "Electron mass (kg)"),
        "m_n":  Description("1.674_927_471E−27",    "Neutron mass (kg)"),
        "m_P":  Description("2.176_470E−8",         "Planck mass (kg)"),
        "m_p":  Description("1.672_621_898E−27",    "Proton mass (kg)"),
        "m_u":  Description("1.660_539_040E−27",    "Atomic mass constant (kg)"),
        "µ_0":  Description("4*π*1E-7",             "Magnetic constant (N A⁻²)"),
        "µ_B":  Description("927.400_9994E−26",     "Bohr magneton (J T⁻¹)"),
        "µ_d":  Description("0.433_073_5040E−26",   "Deuteron magnetic moment (J T⁻¹)"),
        "µ_N":  Description("5.050_783_699E−27",    "Nuclear magneton (J T⁻¹)"),
        "n_0":  Description("2.651_6467E25",        "Loschmidt constant (m⁻³)"),
        "N_A":  Description("6.022_140_857E23",     "Avagadro constant (mol⁻¹)"),
        "φ_0":  Description("2.067_833_831E−15",    "Magnetic flux quantum (Wb)"),
        "r_e":  Description("2.817_940_3227E−15",   "Electron classical radius (m)"),
        "R_K":  Description("25_812.807_4555",      "von Klitzing constant (Ω)"),
        "R":    Description("8.314_4598",           "Molar gas constant (J mol⁻¹ K⁻¹)"),
        "R_∞":  Description("10_973_731.568_508",   "Rydberg constant (m⁻¹)"),
        "σ_e":  Description("0.665_245_871_58E−28", "Electron Thomson cross section (m²)"),
        "σ":    Description("5.670_367E−8",         "Stefan-Boltzmann const. (W m⁻² K⁻⁴)"),
        "t_p":  Description("5.391_16E−44",         "Planck time (s)"),
        "T_P":  Description("1.416_808E32",         "Planck temperature (K)"),
        "V_m":  Description("22.710_947E−3",        "Molar vol. (ideal gas at STP) (m³ mol⁻¹)")
    ]
  
}
