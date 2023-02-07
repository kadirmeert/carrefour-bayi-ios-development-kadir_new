//
//  RequestMultiplierErrorViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.12.2022.
//

import Foundation

protocol RequestMultiplierErrorViewModelDelegate: BaseViewModelDelegate {
    
}


class RequestMultiplierErrorViewModel: BaseViewModel {
    
    weak var delegate: RequestMultiplierErrorViewModelDelegate?
}
