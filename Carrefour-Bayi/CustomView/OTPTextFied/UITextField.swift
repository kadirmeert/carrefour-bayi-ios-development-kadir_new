//
//  UITextField.swift
//  Carrefour-Bayi
//
//  Created by Mert on 26.12.2022.
//

import Foundation
import UIKit

protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }

}
