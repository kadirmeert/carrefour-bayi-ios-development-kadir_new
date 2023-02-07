//
//  SAPRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import Foundation

protocol SAPRepository {
    func getCreditLimit(SAPCode: Int, completion: @escaping(GetCreditLimitResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getStoreDashboardDetail(SAPCode: String, completion: @escaping(GetStoreDashboardDetailResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getAccountingReport(companyCode: String, startDate: String, endDate: String, completion: @escaping(GetAccountingReportResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getAccountingReportExcel(requestModel: GetAccountingReportExcelRequestDTO, completion: @escaping(GetAccountingReportExcelResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}

class DefaultSAPRepository: SAPRepository {
    func getAccountingReport(companyCode: String, startDate: String, endDate: String, completion: @escaping (GetAccountingReportResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getAccountingReportRequestDTO: GetAccountingReportRequestDTO = GetAccountingReportRequestDTO(
            Language: ServiceConfiguration.Language,
            ProcessType: ServiceConfiguration.ProcessType,
            CompanyCode: companyCode,
            StartDate: startDate,
            EndDate: endDate,
            Filter: AccountingFilter(Name: "",
                                     InvoiceDescription: "",
                                     ReferenceNo: "",
                                     DocumentNo: "",
                                     Designation: "",
                                     DocumentType: "",
                                     FirstDate: "1900-01-01",
                                     LastDate: "1900-01-01",
                                     FirstInvoiceDate: "1900-01-01",
                                     LastInvoiceDate: "1900-01-01",
                                     DebtOperator: "",
                                     Debt: -1,
                                     ReceivableOperator: "",
                                     Receivable: -1,
                                     BalanceOperator: "",
                                     Balance: -1))
        
        CipherHelper.encryption(requestDTO: getAccountingReportRequestDTO) { encryptedString in
            SAPService.getAccountingReport(request: encryptedString).request(responseDTO: GetAccountingReportResponseDTO.self) { getAccountingReportResponse in
                if let success = getAccountingReportResponse.Success, success {
                    completion(getAccountingReportResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: getAccountingReportResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getStoreDashboardDetail(SAPCode: String, completion: @escaping (GetStoreDashboardDetailResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getStoreDashboardDetailRequestDTO: GetStoreDashboardDetailRequestDTO = GetStoreDashboardDetailRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, SAPCode: SAPCode)
        
        CipherHelper.encryption(requestDTO: getStoreDashboardDetailRequestDTO) { encryptedString in
            SAPService.getStoreDashboardDetail(request: encryptedString).request(responseDTO: GetStoreDashboardDetailResponseDTO.self) { getStoreDetailDashboardResponse in
                if let success = getStoreDetailDashboardResponse.Success, success {
                    completion(getStoreDetailDashboardResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: getStoreDetailDashboardResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func getCreditLimit(SAPCode: Int, completion: @escaping (GetCreditLimitResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let getCreditLimitRequestDTO: GetCreditLimitRequestDTO = GetCreditLimitRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, SAPCode: SAPCode)
        
        CipherHelper.encryption(requestDTO: getCreditLimitRequestDTO) { encryptedString in
            SAPService.getCreditLimit(request: encryptedString).request(responseDTO: GetCreditLimitResponseDTO.self) { getCreditLimitResponse in
                if let success = getCreditLimitResponse.Success, success {
                    completion(getCreditLimitResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: getCreditLimitResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    func getAccountingReportExcel(requestModel: GetAccountingReportExcelRequestDTO, completion: @escaping (GetAccountingReportExcelResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: requestModel) { encryptedString in
            SAPService.getAccountingReportExcel(request: encryptedString).request(responseDTO: GetAccountingReportExcelResponseDTO.self) { reportExcelResponseDTO in
                if let success = reportExcelResponseDTO.Success, success {
                    completion(reportExcelResponseDTO)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: reportExcelResponseDTO.Message)
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

class MockSAPRepository: SAPRepository {
    func getAccountingReport(companyCode: String, startDate: String, endDate: String, completion: @escaping (GetAccountingReportResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetAccountingReportResponseDTO(Records: [
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941),
                AccountingRecord(Name: "CANKAR KURUMSAL HIZMETLER", InvoiceDescription: "SD Toptan Fatura", ReferenceNo: "CSA2022000822045", DocumentNo: "3004713287", Designation: "7014727010", DocumentType: "Z1", Date: "2022-07-14T00:00:00", InvoiceDate: "2022-08-28T00:00:00", Debt: 2337, Receivable: 0, Balance: 674941)]))
        }
    }
    
    func getStoreDashboardDetail(SAPCode: String, completion: @escaping (GetStoreDashboardDetailResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetStoreDashboardDetailResponseDTO(SAP: 7031, Cari: "34187", TeminatMektubu: 800000.0, AcikSiparisToplami: 116268.35, VadesiGecmisTutar: -40466.36, ToplamBorc: 1731258.29, TeminatiAsanTutar: -1047526.64, OdenecekTutar: -40466.36, ToplamSupurmeliPOS: 1154261.97, ToplamLimit: 2166261.97, KullanilmisLimit: 86.0, KalanLimit: 306777.54))
        }
    }
    
    func getCreditLimit(SAPCode: Int, completion: @escaping (GetCreditLimitResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetCreditLimitResponseDTO(TotalLimit: 269454251.0, RemainingLimit: 134204781.0, UsedLimit: 50.0))
        }
    }
    
    func getAccountingReportExcel(requestModel: GetAccountingReportExcelRequestDTO, completion: @escaping (GetAccountingReportExcelResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
}
