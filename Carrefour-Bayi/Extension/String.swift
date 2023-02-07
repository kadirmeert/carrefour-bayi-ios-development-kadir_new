//
//  String.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation
import CryptoSwift

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ bundleClass: AnyClass) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: bundleClass), value: "", comment: "")
    }
    
    var isValidUserName: Bool {
        return (self.contains("@bilmsoft.site") || self.contains("@carrefoursa.com") || self.contains("@bilmsoft.com")) ? true : false
    }
    
    func formatPhoneNumber(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    var updatedPhoneNumber: String {
        var phoneNumberString = self
        phoneNumberString = phoneNumberString.replacingOccurrences(of: "(", with: "")
        phoneNumberString = phoneNumberString.replacingOccurrences(of: ")", with: "")
        phoneNumberString = phoneNumberString.replacingOccurrences(of: " ", with: "")
        
        return phoneNumberString
    }
    
    
    func formatMasterPassAmount() -> String {
        var endText = "00"
        var textArray = self.map({ String($0) })
        if textArray.count == 1 {
            textArray.append("0")
        }
        endText = textArray.joined()
        return endText
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
