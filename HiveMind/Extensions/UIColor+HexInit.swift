//
//  UIColor+HexInit.swift
//  HiveMind
//
//  Created by Brian Hans on 4/19/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

extension UIColor {
    
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    convenience init(rawRed: CGFloat, rawGreen: CGFloat, rawBlue: CGFloat) {
        self.init(red: rawRed / 255.0, green: rawGreen / 255.0, blue: rawBlue / 255.0, alpha: 1)
    }
    
    // MARK: Special Colors
    
    @nonobjc static var darkOrange: UIColor {
        return UIColor(hex: 0xFB9506)
    }
    
    @nonobjc static var azure: UIColor {
        return UIColor(hex: 0xF7F8F8)
    }
    
    @nonobjc static var goldenTainoi: UIColor {
        return UIColor(hex: 0xFDC462)
    }
    
    @nonobjc static var hiveYellow: UIColor {
        return UIColor(hex: 0xFCEF92)
    }
    
    
    @nonobjc static var aquaHaze: UIColor {
        return UIColor(hex: 0xD5D6D4)
    }
    
    @nonobjc static var craterBrown: UIColor {
        return UIColor(hex: 0x554441)
    }
    
    @nonobjc static var brightGreen: UIColor {
        return UIColor(hex: 0xB8E986)
    }
    
    @nonobjc static var dullRed: UIColor {
        return UIColor(hex: 0xD0011B)
    }
    
    @nonobjc static var paleGray: UIColor {
        return UIColor(hex: 0xEFEFF4)
    }
    
}
