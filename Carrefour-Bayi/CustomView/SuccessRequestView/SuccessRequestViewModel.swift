//
//  SuccessRequestViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.12.2022.
//

import Foundation

protocol SuccessRequestViewModelDelegate: BaseViewModelDelegate {
    
}


class SuccessRequestViewModel: BaseViewModel {
    
    weak var delegate: SuccessRequestViewModelDelegate?
    
}
