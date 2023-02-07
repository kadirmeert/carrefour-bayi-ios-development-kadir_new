//
//  AllRequestViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import Foundation
import UIKit


protocol AllRequestViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
    func deletePurchaseRequestSuccess()
    func ImportPurchaseRequestSuccess()
    
}


class AllRequestViewModel: BaseViewModel {
    weak var delegate: AllRequestViewModelDelegate?
    
    private var requestRepository: PurchaseRequestRepository
    var requestModel: GetAllPurchaseResponseDTO?
    var getFilteredPurchaseRequestDTO: GetAllPurchaseRequestDTO?
    var getAllPurchaseRequestDTO: GetAllPurchaseRequestDTO?
    var currentCompanyAndStore: CurrentCompanyAndStore?
    var currentPage = 1
    
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
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    init(requestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository) {
        self.requestRepository = requestRepository
    }
    
    override func viewWillAppear() {
        getAllRequests()
    }
    
    func getAllRequests() {
        if let companyID = currentCompanyAndStore?.companyID, let storeID = currentCompanyAndStore?.storeID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            
            // sortColumn değeri => "RequestDate"
            getAllPurchaseRequestDTO = GetAllPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                              ProcessType: ServiceConfiguration.ProcessType,
                                                                                              RecordSizeFromPage: 100,
                                                                                              CurrentPage: currentPage,
                                                                                              SortColumn: "RequestDate",
                                                                                              SortColumnAscDesc: "Desc",
                                                                                              CompanyId: companyID, StoreId: storeID,
                                                                                              Filter: PurchaseRequestFilter(Name: nil, FirstDate: nil, LastDate: nil, MaxPrice: nil, MinPrice: nil, StateCodeValue: nil))
            requestRepository.getAll(requestModel: getAllPurchaseRequestDTO!) { getAllRequestResponse in
                self.baseVMDelegate?.contentDidLoad()
                self.requestModel = getAllRequestResponse
                self.delegate?.pageContentSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func fetchMoreRequest(completion: @escaping () -> ()) {
        if getAllPurchaseRequestDTO != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage += 1
            getAllPurchaseRequestDTO?.CurrentPage = currentPage
            requestRepository.getAll(requestModel: getAllPurchaseRequestDTO!) { getAllRequestResponse in
                self.baseVMDelegate?.contentDidLoad()
                self.requestModel?.Data! += getAllRequestResponse.Data!
                completion()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    
    func getFilteredPurchaseRequest(name: String?, minDate: String?, maxDate: String?, maxPrice: Double?, minPrice: Double?, stateCode: Int?, completion: @escaping () -> ()) {
        if let companyID = currentCompanyAndStore?.companyID, let storeID = currentCompanyAndStore?.storeID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage = 1
            getFilteredPurchaseRequestDTO = GetAllPurchaseRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, RecordSizeFromPage: 100, CurrentPage: currentPage, SortColumn: "RequestDate", SortColumnAscDesc: "Desc", CompanyId: companyID, StoreId: storeID, Filter: PurchaseRequestFilter(Name: name, FirstDate: minDate, LastDate: maxDate, MaxPrice: maxPrice, MinPrice: minPrice, StateCodeValue: stateCode))
            requestRepository.getAll(requestModel: getFilteredPurchaseRequestDTO!) { [weak self] getFilteredPurchaseRequestResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.requestModel = getFilteredPurchaseRequestResponse
                self?.delegate?.pageContentSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getMoreFilteredPurchaseRequest(completion: @escaping() -> ()) {
        if getFilteredPurchaseRequestDTO != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage += 1
            getFilteredPurchaseRequestDTO?.CurrentPage = currentPage
            requestRepository.getAll(requestModel: getFilteredPurchaseRequestDTO!) { [weak self] getFilteredPurchaseRequestResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.requestModel?.Data! += getFilteredPurchaseRequestResponse.Data!
                completion()
            } failure: { [weak self] errorDTO in
                //self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    
    func getExcelTemplateToken() {
        let requestModel: GetPurchaseTokenRequestDTO = GetPurchaseTokenRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
        requestRepository.getToken(requestModel: requestModel) { [weak self] purchaseTokenResponse in
            if let url = URL(string: "\(ServiceConfiguration.apiBaseURL)/api/Download/DownloadFile/\(purchaseTokenResponse.Token ?? "")") {
                UIApplication.shared.open(url)
            }
            self?.baseVMDelegate?.contentDidLoad()
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    func deletePurchaseRequest(id: Int?) {
        requestRepository.deletePurchaseRequest(purchaseRequestID: id ?? 0) { response in
            self.delegate?.deletePurchaseRequestSuccess()
            
        } failure: { errorDTO in
            self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self.baseVMDelegate?.contentDidLoad()
        }
    }
    func ImportPurchaseRequest(url: URL) {
        baseVMDelegate?.contentWillLoad()
        let requestModel: ImportPurchaseRequestDTO = ImportPurchaseRequestDTO(CompanyId: currentCompanyAndStore?.companyID ?? 0,
                                                                              StoreId: currentCompanyAndStore?.storeID ?? 0,
                                                                              Language: ServiceConfiguration.Language,
                                                                              ProcessType: ServiceConfiguration.ProcessType)
        requestRepository.importPurchaseRequest(requestModel: requestModel, url: url) { response in
            self.baseVMDelegate?.contentDidLoad()
            self.delegate?.ImportPurchaseRequestSuccess()
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
}
