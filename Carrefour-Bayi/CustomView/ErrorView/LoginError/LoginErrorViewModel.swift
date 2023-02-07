//
//  LoginErrorViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.08.2022.
//

import Foundation

protocol LoginErrorViewModelDelegate: BaseViewModelDelegate {
    
}

class LoginErrorViewModel: BaseViewModel {
    weak var delegate: LoginErrorViewModelDelegate?
}
