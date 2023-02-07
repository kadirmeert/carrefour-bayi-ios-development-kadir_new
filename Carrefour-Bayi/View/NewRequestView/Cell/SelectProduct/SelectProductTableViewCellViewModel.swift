//
//  SelectProductTableViewCellViewModel.swift
//  Carrefour-Bayi
//
//  Created by Mert on 8.01.2023.
//

import Foundation

protocol SelectProductTableViewCellViewModelDelegate: AnyObject {
    func getProductStockInfoSuccess()
    func pageContentFailed(message: String)
}


class SelectProductTableViewCellViewModel {
    
    
    weak var delegate: SelectProductTableViewCellViewModelDelegate?
    
    var productRepository: ProductRepository
    var currentCompanyAndStore: CurrentCompanyAndStore?
    var getProductsByProductNameModel: GetProductsByProductNameResponseDTO?
    
    
    init(productRepository: ProductRepository = RepositoryProvider.productRepository) {
        self.productRepository = productRepository
    }
    
    
    
    func getProductStockInfo() {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetProductsByProductNameRequestDTO = GetProductsByProductNameRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                                      storeSapCode: storeSAPCode,
                                                                                                      text: "",
                                                                                                      RequestDate: "")
            productRepository.getProductsByProductName(requestModel: requestModel) { response in
                self.getProductsByProductNameModel = response
                self.delegate?.getProductStockInfoSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "Ürün Bulunamadı")
                
            }
        }
    }
}
