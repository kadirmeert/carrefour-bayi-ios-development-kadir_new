//
//  PopupViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.09.2022.
//

import Foundation

protocol PopupViewModelDelegate: BaseViewModelDelegate {
    
}

class PopupViewModel: BaseViewModel {
    weak var delegate: PopupViewModelDelegate?
    
    var titleText: String?
    var descriptionText: String?
}
