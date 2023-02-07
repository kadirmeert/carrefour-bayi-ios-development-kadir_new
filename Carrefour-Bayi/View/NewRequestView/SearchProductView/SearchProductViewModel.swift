//
//  SearchProductViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.12.2022.
//

import Foundation

protocol SearchProductViewModelDelegate: BaseViewModelDelegate {
    func searchedProductSuccess()
    func pageContentFailed(message: String)
}


class SearchProductViewModel: BaseViewModel {
    
    weak var delegate: SearchProductViewModelDelegate?
    
    var productRepository: ProductRepository
    
    var searchedProductModel: [ProductModel]?
    
    var currentCompanyAndStore: CurrentCompanyAndStore?
    var requestDate: String?
    var searchedText: String?
    
    var endpointDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var frontendDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    init(productRepository: ProductRepository = RepositoryProvider.productRepository) {
        self.productRepository = productRepository
    }
    
    
    
    override func viewWillAppear() {
       getProductsBySearch()
    }
    
    
    func getProductsBySearch() {
        self.baseVMDelegate?.contentWillLoad()
        if let requestDate = requestDate, let searchedText = searchedText, let storeSAPCode = currentCompanyAndStore?.sapCode {
            let date = frontendDateFormatter.date(from: requestDate)
            let stringDate = endpointDateFormatter.string(from: date ?? Date())
            let requestModel: GetProductsByProductNameRequestDTO = GetProductsByProductNameRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                                      storeSapCode: storeSAPCode,
                                                                                                      text: searchedText,
                                                                                                      RequestDate: stringDate)
#if DEBUG
            print("VEYSEL <<<< request model is here -> ", requestModel, requestDate)
#endif
            productRepository.getProductsByProductName(requestModel: requestModel) { response in
                self.baseVMDelegate?.contentDidLoad()
                self.searchedProductModel = response.getProductsByTextinNameDtos
#if DEBUG
                print("VEYSEL <<<< response model is here -> ", response.getProductsByTextinNameDtos)
#endif
                self.delegate?.searchedProductSuccess()
            } failure: { errorDTO in
                self.baseVMDelegate?.contentDidLoad()
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }        
    }
}
