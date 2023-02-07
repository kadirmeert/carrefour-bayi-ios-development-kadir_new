//
//  GeneralPopupViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 31.08.2022.
//

import Foundation

protocol GeneralPopupViewModelDelegate: BaseViewModelDelegate {
    
}

class GeneralPopupViewModel: BaseViewModel {
    weak var delegate: GeneralPopupViewModelDelegate?
    
    var popupText = ""
}
