//
//  ProductRepository.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

protocol ProductRepository {
    func getAisles(storeSAPCode: Int, text: String, completion: @escaping(GetAislesResponseDTO) -> Void,
                   failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getMainProducts(requestModel: GetMainProductsRequestDTO, completion: @escaping(GetMainProductsResponseDTO) -> Void,
                         failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getMainGroups(requestModel: GetMainGroupsRequestDTO, completion: @escaping(GetMainGroupsResponseDTO) -> Void,
                       failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getMalGroups(requestModel: GetProductGroupsRequestDTO, completion: @escaping(GetMalGroupsResponseDTO) -> Void,
                      failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getProductsByProductName(requestModel: GetProductsByProductNameRequestDTO,
                               completion: @escaping(GetProductsByProductNameResponseDTO) -> Void,
                               failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getProductByBarcode(requestModel: GetProductByBarcodeRequestDTO,
                             completion: @escaping(GetProductByBarcodeResponseDTO) -> Void,
                             failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getProductByStockCode(requestModel: GetProductByStockCodeRequestDTO,
                             completion: @escaping(GetProductByStockCodeResponseDTO) -> Void,
                             failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getProductsFiltered(requestModel: GetProductsFilteredRequestDTO,
                             completion: @escaping(GetProductsFilteredResponseDTO) -> Void,
                             failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getProductInfoFromStocks(requestModel: GetProductInfoFromStocksRequestDTO,
                             completion: @escaping(GetProductInfoFromStocksResponseDTO) -> Void,
                             failure: @escaping(APIErrorMessageProvider?) -> Void)
}




//    MARK: - Default Repository -

class DefaultProductRepository: ProductRepository {

    
    
    
    func getAisles(storeSAPCode: Int, text: String,
                   completion: @escaping (GetAislesResponseDTO) -> Void,
                   failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        let requestModel: GetAislesRequestDTO = GetAislesRequestDTO(ProcessType: ServiceConfiguration.ProcessType,
                                                                    Language: ServiceConfiguration.Language,
                                                                    StoreSapCode: storeSAPCode,
                                                                    Text: text)
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getAisles(request: encryptedString).request(responseDTO: GetAislesResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getMainProducts(requestModel: GetMainProductsRequestDTO,
                         completion: @escaping (GetMainProductsResponseDTO) -> Void,
                         failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getMainProducts(request: encryptedString).request(responseDTO: GetMainProductsResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getMainGroups(requestModel: GetMainGroupsRequestDTO,
                       completion: @escaping (GetMainGroupsResponseDTO) -> Void,
                       failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getMainGroups(request: encryptedString).request(responseDTO: GetMainGroupsResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getMalGroups(requestModel: GetProductGroupsRequestDTO,
                      completion: @escaping (GetMalGroupsResponseDTO) -> Void,
                      failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getMalGroups(request: encryptedString).request(responseDTO: GetMalGroupsResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getProductsByProductName(requestModel: GetProductsByProductNameRequestDTO,
                                  completion: @escaping (GetProductsByProductNameResponseDTO) -> Void,
                                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getProductsByProductName(request: encryptedString).request(responseDTO: GetProductsByProductNameResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getProductByBarcode(requestModel: GetProductByBarcodeRequestDTO,
                             completion: @escaping (GetProductByBarcodeResponseDTO) -> Void,
                             failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getProductByBarcode(request: encryptedString).request(responseDTO: GetProductByBarcodeResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getProductByStockCode(requestModel: GetProductByStockCodeRequestDTO,
                               completion: @escaping (GetProductByStockCodeResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getProductByStockCode(request: encryptedString).request(responseDTO: GetProductByStockCodeResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getProductsFiltered(requestModel: GetProductsFilteredRequestDTO,
                             completion: @escaping (GetProductsFilteredResponseDTO) -> Void,
                             failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getProductsFiltered(request: encryptedString).request(responseDTO: GetProductsFilteredResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getProductInfoFromStocks(requestModel: GetProductInfoFromStocksRequestDTO,
                                  completion: @escaping (GetProductInfoFromStocksResponseDTO) -> Void,
                                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            ProductService.getProductInfoFromStocks(request: encryptedString).request(responseDTO: GetProductInfoFromStocksResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (response).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
}





//    MARK: - Mock Repository -

class MockProductRepository: ProductRepository {
    
    func getAisles(storeSAPCode: Int, text: String,
                   completion: @escaping (GetAislesResponseDTO) -> Void,
                   failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getMainProducts(requestModel: GetMainProductsRequestDTO,
                         completion: @escaping (GetMainProductsResponseDTO) -> Void,
                         failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getMainGroups(requestModel: GetMainGroupsRequestDTO,
                       completion: @escaping (GetMainGroupsResponseDTO) -> Void,
                       failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getMalGroups(requestModel: GetProductGroupsRequestDTO,
                      completion: @escaping (GetMalGroupsResponseDTO) -> Void,
                      failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getProductsByProductName(requestModel: GetProductsByProductNameRequestDTO,
                                  completion: @escaping (GetProductsByProductNameResponseDTO) -> Void,
                                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getProductByBarcode(requestModel: GetProductByBarcodeRequestDTO,
                             completion: @escaping (GetProductByBarcodeResponseDTO) -> Void,
                             failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getProductByStockCode(requestModel: GetProductByStockCodeRequestDTO,
                               completion: @escaping (GetProductByStockCodeResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getProductsFiltered(requestModel: GetProductsFilteredRequestDTO,
                             completion: @escaping (GetProductsFilteredResponseDTO) -> Void,
                             failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getProductInfoFromStocks(requestModel: GetProductInfoFromStocksRequestDTO,
                                  completion: @escaping (GetProductInfoFromStocksResponseDTO) -> Void,
                                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
}
