//
//  OTPCheckErrorViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

protocol OTPCheckErrorViewModelDelegate: BaseViewModelDelegate {
    func reSendCode()
}

class OTPCheckErrorViewModel: BaseViewModel {
    weak var delegate: OTPCheckErrorViewModelDelegate?
    
    func reSendCode() {
        delegate?.reSendCode()
    }
}
