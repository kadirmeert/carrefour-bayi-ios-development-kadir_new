//
//  RegionalManagerRepository.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

protocol RegionalManagerRepository {
    func getRegionalManager(requestDTO: GetRegionalManagerRequestDTO, completion: @escaping(GetRegionalManagerResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func deleteRegionalManager(requestDTO: DeleteRegionalManagerRequestDTO, completion: @escaping(BaseResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func importRegionalManager(url: URL, completion: @escaping(BaseResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getTokenForDownloadExcelTemplate(requestDTO: BaseRequestDTO, completion: @escaping(GetTokenForDownloadExcelTemplateResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getTokenForRegionalManagerDownloadExcel(requestDTO: GetTokenForRegionalManagersDownloadExcelRequestDTO, completion: @escaping(GetTokenForRegionalManagersDownloadExcelResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultRegionalManagerRepository: RegionalManagerRepository {
    func getRegionalManager(requestDTO: GetRegionalManagerRequestDTO, completion: @escaping (GetRegionalManagerResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: requestDTO) { encryptedString in
            RegionalManagerService.getRegionalManager(request: encryptedString).request(responseDTO: GetRegionalManagerResponseDTO.self) { response in
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
    
    func deleteRegionalManager(requestDTO: DeleteRegionalManagerRequestDTO, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: requestDTO) { encryptedString in
            RegionalManagerService.deleteRegionalManager(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { response in
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
    
    func importRegionalManager(url: URL, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
            RegionalManagerService.importRegionalManager(url: url).request(responseDTO: BaseResponseDTO.self) { response in
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
    }
    
    func getTokenForDownloadExcelTemplate(requestDTO: BaseRequestDTO, completion: @escaping (GetTokenForDownloadExcelTemplateResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: requestDTO) { encryptedString in
            RegionalManagerService.getTokenForDownloadExcelTemplate(request: encryptedString).request(responseDTO: GetTokenForDownloadExcelTemplateResponseDTO.self) { response in
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
    
    func getTokenForRegionalManagerDownloadExcel(requestDTO: GetTokenForRegionalManagersDownloadExcelRequestDTO, completion: @escaping (GetTokenForRegionalManagersDownloadExcelResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: requestDTO) { encryptedString in
            RegionalManagerService.getTokenForRegionalManagersDownloadExcel(request: encryptedString).request(responseDTO: GetTokenForRegionalManagersDownloadExcelResponseDTO.self) { response in
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


class MockRegionalManagerRepository: RegionalManagerRepository {
    
    func getRegionalManager(requestDTO: GetRegionalManagerRequestDTO, completion: @escaping (GetRegionalManagerResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func deleteRegionalManager(requestDTO: DeleteRegionalManagerRequestDTO, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func importRegionalManager(url: URL, completion: @escaping (BaseResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getTokenForDownloadExcelTemplate(requestDTO: BaseRequestDTO, completion: @escaping (GetTokenForDownloadExcelTemplateResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func getTokenForRegionalManagerDownloadExcel(requestDTO: GetTokenForRegionalManagersDownloadExcelRequestDTO, completion: @escaping (GetTokenForRegionalManagersDownloadExcelResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
}
