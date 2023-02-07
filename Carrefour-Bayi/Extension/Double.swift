//
//  Double.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.09.2022.
//

import Foundation

extension Double {
    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.alwaysShowsDecimalSeparator = true
        
        var formattedString = formatter.string(from: NSNumber(value: self)) ?? ""
        
        var numbers = formattedString.map({ String($0) })
//        if numbers.last == "," {
//            numbers.append("00")
//        }
        if numbers[numbers.count - 2] == "," {
            numbers.append("0")
        } else if numbers.last == "," {
            numbers.append("00")
        }
        formattedString = numbers.joined()
        
        return formattedString
    }
}

