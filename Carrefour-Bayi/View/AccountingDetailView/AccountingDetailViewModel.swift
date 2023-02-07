//
//  AccountingDetailViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import Foundation
import UIKit

protocol AccountingDetailViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
}

class AccountingDetailViewModel: BaseViewModel {
    weak var delegate: AccountingDetailViewModelDelegate?
    private var sapRepository: SAPRepository
    
    var fieldsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyy"
        return formatter
    }()
    
    var endpointDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter
    }()
    
    var companyCode: String?
    var startDate: String
    var endDate: String
    
    var accountingReport: GetAccountingReportResponseDTO?
    
    init(sapRepository: SAPRepository = RepositoryProvider.sapRepository) {
        self.sapRepository = sapRepository
        
        self.startDate = endpointDateFormatter.string(from: Date())
        self.endDate = endpointDateFormatter.string(from: Date())
    }
    
    override func viewDidAppear() {
        let lastWeekDate = NSCalendar.current.date(byAdding: .weekOfYear, value: -1, to: NSDate() as Date)
        startDate = endpointDateFormatter.string(from: lastWeekDate!)
        getAccountingReport()
        
        super.viewDidAppear()
    }
    
    func getAccountingReport() {
        if let companyCode = companyCode {
            baseVMDelegate?.contentWillLoad()
            sapRepository.getAccountingReport(companyCode: companyCode, startDate: startDate, endDate: endDate) {[weak self] getAccountingReportResponse in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.accountingReport = getAccountingReportResponse
                
                self?.delegate?.pageContentSuccess()
            } failure: {[weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getAccountingReportExcel() {
        if let companyCode = companyCode {
            baseVMDelegate?.contentWillLoad()
            let getAccountingReportExcelRequest = GetAccountingReportExcelRequestDTO(CompanyCode: companyCode,
                                                                                     EndDate: endDate,
                                                                                     StartDate: startDate,
                                                                                     Language: ServiceConfiguration.Language,
                                                                                     ProcessType: ServiceConfiguration.ProcessType)
            
            sapRepository.getAccountingReportExcel(requestModel: getAccountingReportExcelRequest) { [weak self] reportExcelResponse in
                self?.baseVMDelegate?.contentDidLoad()
                if let url = URL(string: "\(ServiceConfiguration.apiBaseURL)/api/Download/DownloadFile/\(reportExcelResponse.Token ?? "")") {
                    UIApplication.shared.open(url)
                }
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}
