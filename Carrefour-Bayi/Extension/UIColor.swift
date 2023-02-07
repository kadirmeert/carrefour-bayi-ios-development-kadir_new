//
//  UIColor.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 5.08.2022.
//

import Foundation
import UIKit

// MARK: - Hex color decoder
public extension UIColor {
    class func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var str = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if(str.hasPrefix("#")) {
            str.remove(at: str.startIndex)
        }
        
        var hex = UInt64()
        Scanner(string: str).scanHexInt64(&hex)
        
        return UIColor(red: CGFloat((hex & 0xff0000)>>16) / 255.0, green: CGFloat((hex & 0x00ff00)>>8) / 255.0, blue: CGFloat(hex & 0x0000ff) / 255.0, alpha: alpha)
    }
}

// MARK: - Theme Colors
extension UIColor {
    static var primaryDarkBlue: UIColor {
        get {
            return UIColor(named: "primaryDarkBlue") ?? fromHex("004797")
        }
    }
    
    static var primaryLightBlue: UIColor {
        get {
            return UIColor(named: "primaryLightBlue") ?? fromHex("7DD8E8")
        }
    }
    
    static var primaryRed: UIColor {
        get {
            return UIColor(named: "primaryRed") ?? fromHex("D21113")
        }
    }
    
    static var primaryTitleBlue: UIColor {
        get {
            return UIColor(named: "primaryTitleBlue") ?? fromHex("004797")
        }
    }
    
    static var opaqueWhite: UIColor {
        get {
            return UIColor(named: "opaqueWhite") ?? UIColor(white: 1, alpha: 0.2)
        }
    }
    
    static var darkBlue: UIColor {
        get {
            return UIColor(named: "darkBlue") ?? fromHex("003D83")
        }
    }
    
    static var primaryDarkGray: UIColor {
        get {
            return UIColor(named: "primaryDarkGray") ?? fromHex("293340")
        }
    }
    
    static var primaryLightGray: UIColor {
        get {
            return UIColor(named: "primaryLightGray") ?? fromHex("E5EAED")
        }
    }
    
    static var secondaryDarkBlue: UIColor {
        get {
            return UIColor(named: "secondaryDarkBlue") ?? fromHex("003A7C")
        }
    }
    
    static var thirdDarkBlue: UIColor {
        get {
            return UIColor(named: "thirdDarkBlue") ?? fromHex("003169")
        }
    }
    
    static var primaryYellow: UIColor {
        get {
            return UIColor(named: "primaryYellow") ?? fromHex("FCD657")
        }
    }
}
