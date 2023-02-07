//
//  StoresViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import Foundation

protocol StoresViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
}

class StoresViewModel: BaseViewModel {
    weak var delegate: StoresViewModelDelegate?
    private var companyRepository: CompanyRepository
    
    var companyAndStoreModel: GetCompanyAndStoreResponseDTO?
    var companyAndStoreList: GetCompanyAndStoreListResponseDTO?
    var companyTableSections: [CompanyTableSection] = []
    var selectedStore: StoreItem?
    var selectedCompanyName: String?
    var selectedStoreName: String?
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    init(companyRepository: CompanyRepository = RepositoryProvider.companyRepository) {
        self.companyRepository = companyRepository
    }
    
    override func viewWillAppear() {
        getCompanyAndStoreList()
        
        super.viewWillAppear()
    }
    
    func getCompanyAndStoreList() {
        if let companyAndStoreModel = companyAndStoreModel, let companyId = companyAndStoreModel.CompanyId {
            baseVMDelegate?.contentWillLoad()
            
            companyRepository.getCompanyAndStoreList(companyId: companyId) {[weak self] getCompanyAndStoreListResponse in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.companyAndStoreList = getCompanyAndStoreListResponse
                
                if let items = getCompanyAndStoreListResponse.Items {
                    self?.companyTableSections = items.map({ companyAndStore in
                        return CompanyTableSection(isHidden: true, companyAndStoreItem: companyAndStore)
                    })
                }
                
                self?.delegate?.pageContentSuccess()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }
    }
    
    func changeSelectedStore(selectedStore: StoreItem) {
        for (companyTableSectionIndex, companyTableSection) in companyTableSections.enumerated() {
            if let stores = companyTableSection.companyAndStoreItem.Stores {
                for (storeIndex, storeItem) in stores.enumerated() {
                    if storeItem.Id == selectedStore.Id {
                        self.selectedStore = selectedStore
                        self.companyTableSections[companyTableSectionIndex].companyAndStoreItem.Stores?[storeIndex] = selectedStore
                        self.delegate?.pageContentSuccess()
                    }
                }
            }
        }
    }
}
