//
//  AdvertisementRepository.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.11.2022.
//

import Foundation

protocol AdvertisementRepository {
    func getAdvertisement(getAdvertisementRequestDTO: GetAdvertisementRequestDTO, completion: @escaping(GetAdvertisementResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultAdvertisementRepository: AdvertisementRepository {
    func getAdvertisement(getAdvertisementRequestDTO: GetAdvertisementRequestDTO, completion: @escaping (GetAdvertisementResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: getAdvertisementRequestDTO) { encryptedString in
            AdvertisementService.getAdvertisement(request: encryptedString).request(responseDTO: GetAdvertisementResponseDTO.self) { getAdvertisementResponse in
                if let success = getAdvertisementResponse.Success, success {
                    completion(getAdvertisementResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getAdvertisementResponse).Message)
                    
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


class MockAdvertisementRepository: AdvertisementRepository {
    func getAdvertisement(getAdvertisementRequestDTO: GetAdvertisementRequestDTO, completion: @escaping (GetAdvertisementResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
    }
}
