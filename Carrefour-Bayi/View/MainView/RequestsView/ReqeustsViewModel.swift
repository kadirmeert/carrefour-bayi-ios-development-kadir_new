//
//  ReqeustsViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import Foundation

protocol RequestsViewModelDelegate: BaseViewModelDelegate {
    
}

class RequestsViewModel: BaseViewModel {
    
    weak var delegate: RequestsViewModelDelegate?
    
    
    var purchaseRequestResponseModel: GetAllPurchaseResponseDTO?
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    override func viewWillAppear() {
        loadContent()
    }
    
    func loadContent() {
    }
}
