//
//  ProductCategoriesTableViewCellViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 24.12.2022.
//

import Foundation


protocol ProductCategoriesTableViewCellViewModelDelegate: AnyObject {
    func getMainGroupsSuccess()
    func getMainProductsSuccess()
    func getProductGroupsSuccess()
    func pageContentFailed(message: String)
}


class ProductCategoriesTableViewCellViewModel {
    
    weak var delegate: ProductCategoriesTableViewCellViewModelDelegate?
    
    var productRepository: ProductRepository
    
    var currentCompanyAndStore: CurrentCompanyAndStore?
    var aislesModel: [AisleModel]?
    var mainProductsModel: [AisleModel]?
    var mainGroupsModel: [AisleModel]?
    var productGroupsModel: [AisleModel]?
    var searchedProductModel: [ProductModel]?
    
    
    init(productRepository: ProductRepository = RepositoryProvider.productRepository) {
        self.productRepository = productRepository
    }
    
    
    func  getMainProducts(aisleCode: Int)  {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetMainGroupsRequestDTO = GetMainGroupsRequestDTO(Language: ServiceConfiguration.Language,
                                                                                ProcessType: ServiceConfiguration.ProcessType,
                                                                                StoreSAPCode: storeSAPCode,
                                                                                AnaHamKodu: aisleCode,
                                                                                Text: "")
            
            productRepository.getMainGroups(requestModel: requestModel) { response in
                self.mainGroupsModel = response.getAnaGruplarDtos
                self.delegate?.getMainGroupsSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }
    }
    
    
    func getProductGroups(mainGroupCode: Int) {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetMainProductsRequestDTO = GetMainProductsRequestDTO(Language: ServiceConfiguration.Language,
                                                                                    ProcessType: ServiceConfiguration.ProcessType,
                                                                                    StoreSAPCode: storeSAPCode,
                                                                                    reyonkodu: mainGroupCode,
                                                                                    Text: "")
            
            productRepository.getMainProducts(requestModel: requestModel) { response in
                self.mainProductsModel = response.getAnaHamlarDtos
                self.delegate?.getMainProductsSuccess()
                

            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }
    }
    
    
    func getMainGroups(mainProductCode: Int)  {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetProductGroupsRequestDTO = GetProductGroupsRequestDTO(Language: ServiceConfiguration.Language,
                                                                                     ProcessType: ServiceConfiguration.ProcessType,
                                                                                     StoreSAPCode: storeSAPCode,
                                                                                     AnaGrupKodu: mainProductCode,
                                                                                     Text: "")
            productRepository.getMalGroups(requestModel: requestModel) { response in
                self.productGroupsModel = response.getMalGruplarDtos
                self.delegate?.getProductGroupsSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }
    }
}
