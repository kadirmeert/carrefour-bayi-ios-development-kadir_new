//
//  CompanyRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

protocol CompanyRepository {
    func getCompanyAndStore(completion: @escaping(GetCompanyAndStoreResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getCompanies(companyId: Int, completion: @escaping(GetCompaniesResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getStore(companyId: Int, completion: @escaping(GetStoreResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getCompanyAndStoreList(companyId: Int, completion: @escaping(GetCompanyAndStoreListResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultCompanyRepository: CompanyRepository {
    func getCompanyAndStoreList(companyId: Int, completion: @escaping (GetCompanyAndStoreListResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getCompanyAndStoreListRequestDTO: GetCompanyAndStoreListRequestDTO = GetCompanyAndStoreListRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, CompanyId: companyId)
        
        CipherHelper.encryption(requestDTO: getCompanyAndStoreListRequestDTO) { encryptedString in
            CompanyService.getCompanyAndStoreList(request: encryptedString).request(responseDTO: GetCompanyAndStoreListResponseDTO.self) { getCompanyAndStoreListResponse in
                if let success = getCompanyAndStoreListResponse.Success, success {
                    completion(getCompanyAndStoreListResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getCompanyAndStoreListResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getStore(companyId: Int, completion: @escaping (GetStoreResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getStoreRequestDTO: GetStoreRequestDTO = GetStoreRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, CompanyId: companyId)
        
        CipherHelper.encryption(requestDTO: getStoreRequestDTO) { encryptedString in
            CompanyService.getStore(request: encryptedString).request(responseDTO: GetStoreResponseDTO.self) { getStoreResponse in
                if let success = getStoreResponse.Success, success {
                    completion(getStoreResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getStoreResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getCompanies(companyId: Int, completion: @escaping (GetCompaniesResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getCompaniesRequestDTO: GetCompaniesRequestDTO = GetCompaniesRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, CompanyId: companyId)
        
        CipherHelper.encryption(requestDTO: getCompaniesRequestDTO) { encryptedString in
            CompanyService.getCompanies(request: encryptedString).request(responseDTO: GetCompaniesResponseDTO.self) { getCompaniesResponse in
                if let success = getCompaniesResponse.Success, success {
                    completion(getCompaniesResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getCompaniesResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getCompanyAndStore(completion: @escaping (GetCompanyAndStoreResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        if let userData = RepositoryProvider.tokenRepository.getUserData(), let companyId = userData.CompanyId, let storeId = userData.StoreId {
            let getCompanyAndStoreRequestDTO: GetCompanyAndStoreRequestDTO = GetCompanyAndStoreRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, CompanyId: companyId, StoreId: storeId)
            
            CipherHelper.encryption(requestDTO: getCompanyAndStoreRequestDTO) { encryptedString in
                CompanyService.getCompanyAndStore(request: encryptedString).request(responseDTO: GetCompanyAndStoreResponseDTO.self) { getCompanyAndStoreResponse in
                    if let success = getCompanyAndStoreResponse.Success, success {
                        completion(getCompanyAndStoreResponse)
                    }
                    else {
                        var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                        errorDTO = APIErrorResponseDTO(Message: (getCompanyAndStoreResponse).Message)
                        
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
}

class MockCompanyRepository: CompanyRepository {
    func getCompanyAndStoreList(companyId: Int, completion: @escaping (GetCompanyAndStoreListResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(GetCompanyAndStoreListResponseDTO(Items: [CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")]), CompanyAndStore(Company: CompanyItem(Id: 73, CityId: 34, DistrictId: 834, CompanyCode: "0000033966", CompanyName: "İstanbul Heybeliada Mini", TaxOffice: "Kadıköy VD", TaxNumber: "4980500716", Address: "Ayyıldız C. No:15", CompanyType: 6, Phone: "(545) 419-1923", EmailAddress: "@bayi.carrefoursa.com"), Stores: [StoreItem(Id: 6, CompanyId: 73, Name: "İstanbul Heybeliada Mini", Address: "Ayyıldız C. No:15", CityId: 34, DistrictId: 834, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "@bayi.carrefoursa.com", SAPCode: "7002")])]))
        }
    }
    
    func getStore(companyId: Int, completion: @escaping (GetStoreResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let getStoreResponseDTO = GetStoreResponseDTO(Success: true, Message: "", StoreList: [
                Store(Name: "İstanbul Heybeliada Mini", Address: "Heybeliada M. Ayyıldız C. No:15 ", IsActive: true, CityId: 34, DistrictId: 834, CompanyId: 73, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "istanbulheybeliada7002@bayi.carrefoursa.com", SAPCode: "7002", CityName: nil, DistrictName: nil, UpdatedByUserId: 4, UpdatedDate: "2022-05-16T17:20:08.54", IsDeleted: false, Id: 6, InsertDate: "2022-03-15T00:00:00", TotalRowCount: 0),
                Store(Name: "İstanbul Heybeliada Mini 2", Address: "Heybeliada M. Ayyıldız C. No:15 ", IsActive: true, CityId: 34, DistrictId: 834, CompanyId: 73, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "istanbulheybeliada7002@bayi.carrefoursa.com", SAPCode: "7002", CityName: nil, DistrictName: nil, UpdatedByUserId: 4, UpdatedDate: "2022-05-16T17:20:08.54", IsDeleted: false, Id: 6, InsertDate: "2022-03-15T00:00:00", TotalRowCount: 0),
                Store(Name: "İstanbul Heybeliada Mini 3", Address: "Heybeliada M. Ayyıldız C. No:15 ", IsActive: true, CityId: 34, DistrictId: 834, CompanyId: 73, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "istanbulheybeliada7002@bayi.carrefoursa.com", SAPCode: "7002", CityName: nil, DistrictName: nil, UpdatedByUserId: 4, UpdatedDate: "2022-05-16T17:20:08.54", IsDeleted: false, Id: 6, InsertDate: "2022-03-15T00:00:00", TotalRowCount: 0),
                Store(Name: "İstanbul Heybeliada Mini 4", Address: "Heybeliada M. Ayyıldız C. No:15 ", IsActive: true, CityId: 34, DistrictId: 834, CompanyId: 73, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "istanbulheybeliada7002@bayi.carrefoursa.com", SAPCode: "7002", CityName: nil, DistrictName: nil, UpdatedByUserId: 4, UpdatedDate: "2022-05-16T17:20:08.54", IsDeleted: false, Id: 6, InsertDate: "2022-03-15T00:00:00", TotalRowCount: 0),
                Store(Name: "İstanbul Heybeliada Mini 5", Address: "Heybeliada M. Ayyıldız C. No:15 ", IsActive: true, CityId: 34, DistrictId: 834, CompanyId: 73, StoreType: 8, OpeningDate: "2020-03-19T00:00:00", Contact: "Nursel KAPLAN", Phone: "545 419 19 23", EmailAddress: "istanbulheybeliada7002@bayi.carrefoursa.com", SAPCode: "7002", CityName: nil, DistrictName: nil, UpdatedByUserId: 4, UpdatedDate: "2022-05-16T17:20:08.54", IsDeleted: false, Id: 6, InsertDate: "2022-03-15T00:00:00", TotalRowCount: 0)])
            
            completion(getStoreResponseDTO)
        }
    }
    
    func getCompanies(companyId: Int, completion: @escaping (GetCompaniesResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let getCompaniesResponseDTO = GetCompaniesResponseDTO(Success: true, Message: "", companies: [
                Company(Id: 154, CompanyName: "BIRLIK YATIRIM", CompanyCode: "0000034507"),
                Company(Id: 155, CompanyName: "BIRLIK YATIRIM 2", CompanyCode: "0000034507"),
                Company(Id: 156, CompanyName: "BIRLIK YATIRIM 3", CompanyCode: "0000034507"),
                Company(Id: 157, CompanyName: "BIRLIK YATIRIM 4", CompanyCode: "0000034507"),
                Company(Id: 158, CompanyName: "BIRLIK YATIRIM 5", CompanyCode: "0000034507"),
                Company(Id: 159, CompanyName: "BIRLIK YATIRIM 6", CompanyCode: "0000034507"),
                Company(Id: 160, CompanyName: "BIRLIK YATIRIM 7", CompanyCode: "0000034507")])
            
            completion(getCompaniesResponseDTO)
        }
    }
    
    func getCompanyAndStore(completion: @escaping (GetCompanyAndStoreResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetCompanyAndStoreResponseDTO(CompanyId: 0, CompanyName: "Company", StoreId: 0, StoreName: "Store", SAPCode: "1111", CompanyCode: "00000000000"))
        }
    }
}
