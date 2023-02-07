//
//  UpdateProductQuantityViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.12.2022.
//

import Foundation

protocol UpdateProductQuantityViewModelDelegate: BaseViewModelDelegate {
    
}


class UpdateProductQuantityViewModel: BaseViewModel {
    
    weak var delegate: UpdateProductQuantityViewModelDelegate?
    
}
