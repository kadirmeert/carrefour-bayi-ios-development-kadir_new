//
//  SuccessLoginViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.08.2022.
//

import Foundation

protocol SuccessLoginViewModelDelegate: BaseViewModelDelegate {
    
}

class SuccessLoginViewModel: BaseViewModel {
    weak var delegate: SuccessLoginViewModelDelegate?
    
    private var companyRepository: CompanyRepository
    
    var companyAndStoreModel: GetCompanyAndStoreResponseDTO?
    
    init(companyRepository: CompanyRepository = RepositoryProvider.companyRepository) {
        self.companyRepository = companyRepository
    }
    
    override func viewWillAppear() {
        getCompanyAndStore()
    }
    
    func getCompanyAndStore() {
        companyRepository.getCompanyAndStore {[weak self] getCompanyAndStoreResponse in
            self?.companyAndStoreModel = getCompanyAndStoreResponse
        } failure: { errorDTO in
            #if DEBUG
            print(errorDTO ?? "generalErrorMessage".localized)
            #endif
        }
    }
}
