//
//  PaymentAmountTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 19.12.2022.
//


import UIKit

protocol PaymentAmountTableViewCellDelegate {
    func paymentAmountChanged(paymentAmount: String)
}


class PaymentAmountTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var integerAmountTextField: UITextField!
    @IBOutlet weak var decimalAmountTextField: UITextField!
    
    var delegate: PaymentAmountTableViewCellDelegate?
    
    var paymentAmount: String = "00"
    
    
    func bind() {
        integerAmountTextField.delegate = self
        decimalAmountTextField.delegate = self
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let enteredText = textField.text else {
            return
        }
        if textField == integerAmountTextField {
            let decimalText: String = decimalAmountTextField.text == "" ? "00" : decimalAmountTextField.text!.formatMasterPassAmount()
            paymentAmount = enteredText + decimalText
            delegate?.paymentAmountChanged(paymentAmount: paymentAmount)
        } else {
            let integerText: String = integerAmountTextField.text == "" ? "0" : integerAmountTextField.text!
            paymentAmount = integerText + enteredText.formatMasterPassAmount()
            delegate?.paymentAmountChanged(paymentAmount: paymentAmount)
        }
    }
}
