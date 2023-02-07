//
//  PurchaseRequestRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

protocol PurchaseRequestRepository {
    func getAll(requestModel: GetAllPurchaseRequestDTO,
                completion: @escaping(GetAllPurchaseResponseDTO) -> Void,
                failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getToken(requestModel: GetPurchaseTokenRequestDTO,
                  completion: @escaping(GetPurchaseTokenResponseDTO) -> Void,
                  failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func getRequestDetail(requestModel: GetPurchaseRequestDetailRequestDTO,
                          completion: @escaping(GetPurchaseRequestDetailResponseDTO) -> Void,
                          failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func deletePurchaseRequest(purchaseRequestID: Int,
                               completion: @escaping(BaseResponseDTO) -> Void,
                               failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func createPurchaseRequestGetSerialNumber(storeID: Int,
                                              completion: @escaping(CreatePurchaseRequestGetSerialNumberResponseDTO) -> Void,
                                              failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func createPurchaseRequest(requestModel: CreatePurchaseRequestDTO,
                               completion: @escaping(CreatePurchaseResponseDTO) -> Void,
                               failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func createPurchaseRequestDetail(requestModel: CreatePurchaseRequestDetailDTO,
                                     completion: @escaping(CreatePurchaseDetailResponseDTO) -> Void,
                                     failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func deletePurchaseRequestDetail(PurchaseRequestDetailId: Int,
                                     completion: @escaping(DeletePurchaseRequestDetailResponseDTO) -> Void,
                                     failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func updatePurchaseRequestDetail(requestModel: UpdatePurchaseRequestDetailDTO,
                                     completion: @escaping(UpdatePurchaseResponseDTO) -> Void,
                                     failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func importPurchaseRequest(requestModel: ImportPurchaseRequestDTO, url: URL,
                               completion: @escaping(BaseResponseDTO) -> Void,
                               failure: @escaping(APIErrorMessageProvider?) -> Void)
    
    func sendRequest(requestModel: SendPurchaseRequestDTO,
                    completion: @escaping(BaseResponseDTO) -> Void,
                    failure: @escaping(APIErrorMessageProvider?) -> Void)
}




class DefaultPurchaseRequestRepository: PurchaseRequestRepository {
    
    func getAll(requestModel: GetAllPurchaseRequestDTO,
                completion: @escaping (GetAllPurchaseResponseDTO) -> Void,
                failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.getAll(request: encryptedString).request(responseDTO: GetAllPurchaseResponseDTO.self) { getAllRequestResponse in
                if let success = getAllRequestResponse.Success, success {
                    completion(getAllRequestResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getAllRequestResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getToken(requestModel: GetPurchaseTokenRequestDTO,
                  completion: @escaping (GetPurchaseTokenResponseDTO) -> Void,
                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.getToken(request: encryptedString).request(responseDTO: GetPurchaseTokenResponseDTO.self) { getPurchaseTokenResponse in
                if let success = getPurchaseTokenResponse.Success, success {
                    completion(getPurchaseTokenResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getPurchaseTokenResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getRequestDetail(requestModel: GetPurchaseRequestDetailRequestDTO,
                          completion: @escaping (GetPurchaseRequestDetailResponseDTO) -> Void,
                          failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.getPurchaseRequestDetail(request: encryptedString).request(responseDTO: GetPurchaseRequestDetailResponseDTO.self) { getPurchaseRequestDetailResponse in
                if let success = getPurchaseRequestDetailResponse.Success, success {
                    completion(getPurchaseRequestDetailResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getPurchaseRequestDetailResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func deletePurchaseRequest(purchaseRequestID: Int,
                               completion: @escaping (BaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        let requestModel: DeletePurchaseRequestDTO = DeletePurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                              ProcessType: ServiceConfiguration.ProcessType,
                                                                              Id: purchaseRequestID)
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.deletePurchaseRequest(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { deletePurchaseResponse in
                if let success = deletePurchaseResponse.Success, success {
                    completion(deletePurchaseResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (deletePurchaseResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func createPurchaseRequestGetSerialNumber(storeID: Int,
                                              completion: @escaping (CreatePurchaseRequestGetSerialNumberResponseDTO) -> Void,
                                              failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        let requestModel: CreatePurchaseRequestGetSerialNumberRequestDTO = CreatePurchaseRequestGetSerialNumberRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                                          ProcessType: ServiceConfiguration.ProcessType,
                                                                                                                          StoreId: storeID)
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.createPurchaseRequestGetSerialNumber(request: encryptedString).request(responseDTO: CreatePurchaseRequestGetSerialNumberResponseDTO.self) { response in
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
    
    func createPurchaseRequest(requestModel: CreatePurchaseRequestDTO,
                               completion: @escaping (CreatePurchaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.createPurchaseRequest(request: encryptedString).request(responseDTO: CreatePurchaseResponseDTO.self) { createPurchaseResponse in
                if let success = createPurchaseResponse.Success, success {
                    completion(createPurchaseResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (createPurchaseResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func createPurchaseRequestDetail(requestModel: CreatePurchaseRequestDetailDTO,
                                     completion: @escaping (CreatePurchaseDetailResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.createPurchaseRequestDetail(request: encryptedString).request(responseDTO: CreatePurchaseDetailResponseDTO.self) { createPurchaseDetailResponse in
                if let success = createPurchaseDetailResponse.Success, success {
                    completion(createPurchaseDetailResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (createPurchaseDetailResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func deletePurchaseRequestDetail(PurchaseRequestDetailId: Int,
                                     completion: @escaping (DeletePurchaseRequestDetailResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        let requestModel: DeletePurchaseRequestDetailDTO = DeletePurchaseRequestDetailDTO(Language: ServiceConfiguration.Language,
                                                                                          ProcessType: ServiceConfiguration.ProcessType,
                                                                                          PurchaseRequestDetailId: PurchaseRequestDetailId)
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.deletePurchaseRequestDetail(request: encryptedString).request(responseDTO: DeletePurchaseRequestDetailResponseDTO.self) { response in
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
    
    func updatePurchaseRequestDetail(requestModel: UpdatePurchaseRequestDetailDTO,
                                     completion: @escaping (UpdatePurchaseResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.updatePurchaseRequestDetail(request: encryptedString).request(responseDTO: UpdatePurchaseResponseDTO.self) { updatePurchaseResponse in
                if let success = updatePurchaseResponse.Success, success {
                    completion(updatePurchaseResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (updatePurchaseResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func importPurchaseRequest(requestModel: ImportPurchaseRequestDTO, url: URL,
                               completion: @escaping (BaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.importPurchaseRequest(request: encryptedString, url: url).request(responseDTO: BaseResponseDTO.self) { importPurchaseResponse in
                if let success = importPurchaseResponse.Success, success {
                    completion(importPurchaseResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (importPurchaseResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func sendRequest(requestModel: SendPurchaseRequestDTO,
                    completion: @escaping (BaseResponseDTO) -> Void,
                    failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            PurchaseRequestService.sendRequest(request: encryptedString).request(responseDTO: BaseResponseDTO.self) { sendResponse in
                if let success = sendResponse.Success, success {
                    completion(sendResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (sendResponse).Message)
                    
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





class MockPurchaseRequestRepository: PurchaseRequestRepository {
    func getAll(requestModel: GetAllPurchaseRequestDTO,
                completion: @escaping (GetAllPurchaseResponseDTO) -> Void,
                failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetAllPurchaseResponseDTO(Success: true, Message: "",
                                                 info: PurchaseRequestInfo(Count: 1545, Pages: 154, Next: "2", Prev: nil),
                                                 Data: [PurchaseRequestData(Id: 96, InsertDate: "2022-03-18T22:15:18.107", Name: "P002 - 700200001", CompanyId: 73, StoreId: 6, RequestDate: "2022-03-18T00:00:00", StateCode: 1, SubProductCount: 0, UpdatedByUserId: 4, UpdatedDate: "2022-03-18T22:15:18.107", IsDeleted: false, TotalPrice: 0.0, StateCodeValue: "Talebi göndermediniz", TotalRowCount: 1545)]))
        }
    }
    func getToken(requestModel: GetPurchaseTokenRequestDTO,
                  completion: @escaping (GetPurchaseTokenResponseDTO) -> Void,
                  failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func getRequestDetail(requestModel: GetPurchaseRequestDetailRequestDTO,
                          completion: @escaping (GetPurchaseRequestDetailResponseDTO) -> Void,
                          failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func deletePurchaseRequest(purchaseRequestID: Int,
                               completion: @escaping (BaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func createPurchaseRequestGetSerialNumber(storeID: Int,
                                              completion: @escaping (CreatePurchaseRequestGetSerialNumberResponseDTO) -> Void,
                                              failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
    
    func createPurchaseRequest(requestModel: CreatePurchaseRequestDTO,
                               completion: @escaping (CreatePurchaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func createPurchaseRequestDetail(requestModel: CreatePurchaseRequestDetailDTO,
                                     completion: @escaping (CreatePurchaseDetailResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func deletePurchaseRequestDetail(PurchaseRequestDetailId: Int,
                                     completion: @escaping (DeletePurchaseRequestDetailResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func updatePurchaseRequestDetail(requestModel: UpdatePurchaseRequestDetailDTO,
                                     completion: @escaping (UpdatePurchaseResponseDTO) -> Void,
                                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func importPurchaseRequest(requestModel: ImportPurchaseRequestDTO, url: URL,
                               completion: @escaping (BaseResponseDTO) -> Void,
                               failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func sendRequest(requestModel: SendPurchaseRequestDTO,
                     completion: @escaping (BaseResponseDTO) -> Void,
                     failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
}


