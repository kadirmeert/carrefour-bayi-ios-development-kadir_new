//
//  MasterPassRepository.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


protocol MasterPassRepository {
    func getToken(requestModel: GetMasterPassTokenRequestDTO,
                  completion: @escaping(GetMasterPassTokenResponseDTO) -> Void,
                  failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getMasterPassInfo(requestModel: GetMasterPassInfoRequestDTO,
                           completion: @escaping(GetMasterPassInfoResponseDTO) -> Void,
                           failure: @escaping(APIErrorMessageProvider?) -> Void)
    func insertPurchase(requestModel: InsertPurchaseRequestDTO,
                        completion: @escaping(BaseResponseDTO) -> Void,
                        failure: @escaping(APIErrorMessageProvider?) -> Void)
    func insertDirectPurchase(requestModel: InsertDirectPurchaseRequestDTO,
                              completion: @escaping(BaseResponseDTO) -> Void,
                              failure: @escaping(APIErrorMessageProvider?) -> Void)
    func insertRegisterPurchase(requestModel: InsertRegisterPurchaseRequestDTO,
                                completion: @escaping(BaseResponseDTO) -> Void,
                                failure: @escaping(APIErrorMessageProvider?) -> Void)
    func commitPurchase(requestModel: MasterPassCommitPurchaseRequestDTO,
                        completion: @escaping(BaseResponseDTO) -> Void,
                        failure: @escaping(APIErrorMessageProvider?) -> Void)
    func insertResponse(requestModel: MasterPassInsertResponseRequestDTO,
                        completion: @escaping(BaseResponseDTO) -> Void,
                        failure: @escaping(APIErrorMessageProvider?) -> Void)
}


class DefaultMasterPassRepository: MasterPassRepository {
    
    func getToken(requestModel: GetMasterPassTokenRequestDTO,
                  completion: @escaping (GetMasterPassTokenResponseDTO) -> Void,
                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.getToken(request: encryptedString).request(responseDTO: GetMasterPassTokenResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func getMasterPassInfo(requestModel: GetMasterPassInfoRequestDTO,
                           completion: @escaping (GetMasterPassInfoResponseDTO) -> Void,
                           failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.getMasterPassInfo(request: encryptedString).request(responseDTO: GetMasterPassInfoResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func insertPurchase(requestModel: InsertPurchaseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.insertPurchase(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func insertDirectPurchase(requestModel: InsertDirectPurchaseRequestDTO,
                              completion: @escaping (BaseResponseDTO) -> Void,
                              failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.insertDirectPurchase(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func insertRegisterPurchase(requestModel: InsertRegisterPurchaseRequestDTO,
                                completion: @escaping (BaseResponseDTO) -> Void,
                                failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.insertRegisterPurchase(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func commitPurchase(requestModel: MasterPassCommitPurchaseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.commitPurchase(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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
    
    func insertResponse(requestModel: MasterPassInsertResponseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            MasterPassService.insertResponse(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
                if let success = response.Success, success {
                    completion(response)
                }
                else {
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




class MockMasterPassRepository: MasterPassRepository {
    func insertPurchase(requestModel: InsertPurchaseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func insertDirectPurchase(requestModel: InsertDirectPurchaseRequestDTO,
                              completion: @escaping (BaseResponseDTO) -> Void,
                              failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func insertRegisterPurchase(requestModel: InsertRegisterPurchaseRequestDTO,
                                completion: @escaping (BaseResponseDTO) -> Void,
                                failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getToken(requestModel: GetMasterPassTokenRequestDTO,
                  completion: @escaping (GetMasterPassTokenResponseDTO) -> Void,
                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getMasterPassInfo(requestModel: GetMasterPassInfoRequestDTO,
                           completion: @escaping (GetMasterPassInfoResponseDTO) -> Void,
                           failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func commitPurchase(requestModel: MasterPassCommitPurchaseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func insertResponse(requestModel: MasterPassInsertResponseRequestDTO,
                        completion: @escaping (BaseResponseDTO) -> Void,
                        failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
}
