//
//  CityRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

protocol CityRepository {
    func getCities(completion: @escaping([City]) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getDistricts(cityId: Int, completion: @escaping([District]) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultCityRepository: CityRepository {
    func getCities(completion: @escaping ([City]) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getCitiesRequestDTO: BaseRequestDTO = BaseRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
        
        CipherHelper.encryption(requestDTO: getCitiesRequestDTO) { encryptedString in
            CityService.getCities(request: encryptedString).request(responseDTO: GetCitiesResponseDTO.self) { getCitiesResponse in
                if let success = getCitiesResponse.Success, success {
                    print("getCities Response:\n\(getCitiesResponse)")
                    guard let cities = getCitiesResponse.Cities else {
                        return failure(nil)
                    }
                    
                    completion(cities)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: getCitiesResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getDistricts(cityId cityID: Int, completion: @escaping ([District]) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getDistrictsRequestDTO: GetDistrictsRequestDTO = GetDistrictsRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, CityId: cityID)
        
        CipherHelper.encryption(requestDTO: getDistrictsRequestDTO) { encryptedString in
            CityService.getDistricts(request: encryptedString).request(responseDTO: GetDistrictsResponseDTO.self) { getDistrictsResponse in
                if let success = getDistrictsResponse.Success, success {
                    print("getDistricts Response:\n\(getDistrictsResponse)")
                    
                    guard let districts = getDistrictsResponse.Districts else {
                        return failure(nil)
                    }
                    
                    completion(districts)
                }
                else{
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: getDistrictsResponse.Message)
                    
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

class MockCityRepository: CityRepository {
    func getCities(completion: @escaping ([City]) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([City(Id: 1, Name: "Adana"), City(Id: 55, Name: "Samsun")])
        }
    }
    
    func getDistricts(cityId: Int, completion: @escaping ([District]) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([District(Id: 111, Name: "Aladağ"), District(Id: 222, Name: "Atakum")])
        }
    }
}
