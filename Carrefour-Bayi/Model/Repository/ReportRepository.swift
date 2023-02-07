//
//  ReportRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

protocol ReportRepository {
    func getAllReports(SAPCode: Int, completion: @escaping(GetAllReportsResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultReportRepository: ReportRepository {
    func getAllReports(SAPCode: Int, completion: @escaping (GetAllReportsResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getAllReportsRequestDTO: GetAllReportsRequestDTO = GetAllReportsRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, SAPCode: SAPCode)
        
        CipherHelper.encryption(requestDTO: getAllReportsRequestDTO) { encryptedString in
            ReportService.getAllReports(request: encryptedString).request(responseDTO: GetAllReportsResponseDTO.self) { getAllReportsResponse in
                if let success = getAllReportsResponse.Success, success {
                    completion(getAllReportsResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getAllReportsResponse).Message)
                    
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

class MockReportRepository: ReportRepository {
    func getAllReports(SAPCode: Int, completion: @escaping (GetAllReportsResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetAllReportsResponseDTO(Reports: [Report(Url: "https://www.google.com.tr", ReportName: .storeMonthly)]))
        }
    }
}
