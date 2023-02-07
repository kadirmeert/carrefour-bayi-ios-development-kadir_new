//
//  MainViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.08.2022.
//

import Foundation

protocol MainViewModelDelegate: BaseViewModelDelegate {
    func getCreditLimitSuccess(response: GetCreditLimitResponseDTO)
    func getCompanyAndStoreSuccess(response: GetCompanyAndStoreResponseDTO)
    func getAllReportsSuccess(response: GetAllReportsResponseDTO)
    func purchaseRequestSuccess(response: GetAllPurchaseResponseDTO)
    func advertisementRequestSuccess(response: [GetAdvertisementData]?)
    func pageContentFailed(errorMessage: String)
}

enum TabState {
    case requestsTabUp
    case orderTabUp
    case menuTabUp
    case accountingTabUp
    case dashboardTabUp
    case none
}

class MainViewModel: BaseViewModel {
    weak var delegate: MainViewModelDelegate?
    
    private var sapRepository: SAPRepository
    private var companyRepository: CompanyRepository
    private var reportRepository: ReportRepository
    private var purchaseRequestRepository: PurchaseRequestRepository
    private var advertisementRepository: AdvertisementRepository
    private var notificationRepository: NotificationRepository
    
    var creditLimitModel: GetCreditLimitResponseDTO?
    var companyAndStoreModel: GetCompanyAndStoreResponseDTO?
    var allReportsModel: GetAllReportsResponseDTO?
    var purchaseRequestResponseModel: GetAllPurchaseResponseDTO?
    var currentCompanyAndStore: CurrentCompanyAndStore?
    var advertisementModel: [GetAdvertisementData]?
    
    private var dispatchGroup: DispatchGroup?
    private var isPageContentFailed: Bool
    private var errorDTO: APIErrorMessageProvider?
    
    var tabState: TabState = .none
    
    var catalogUrl: String = "https://www.carrefoursa.com/kataloglar"
    var giftCardUrl: String = "https://www.carrefoursa.com/hediye-kart"
    
    init(sapRepository: SAPRepository = RepositoryProvider.sapRepository,
         companyRepository: CompanyRepository = RepositoryProvider.companyRepository,
         reportRepository: ReportRepository = RepositoryProvider.reportRepository,
         purchaseRequestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository,
         advertisementRepository: AdvertisementRepository = RepositoryProvider.advertisementRepository,
         notificationRepository: NotificationRepository = RepositoryProvider.notificationRepository) {
        self.sapRepository = sapRepository
        self.companyRepository = companyRepository
        self.reportRepository = reportRepository
        self.purchaseRequestRepository = purchaseRequestRepository
        self.advertisementRepository = advertisementRepository
        self.notificationRepository = notificationRepository
        isPageContentFailed = false
    }
    
    override func viewWillAppear() {
        loadContent()
        super.viewWillAppear()
    }
    
    func loadContent() {
        baseVMDelegate?.contentWillLoad()
        dispatchGroup = DispatchGroup()
        
        isPageContentFailed = false
        
        if companyAndStoreModel == nil {
            dispatchGroup?.enter()
            companyRepository.getCompanyAndStore {[weak self] getCompanyAndStoreResponse in
                self?.companyAndStoreModel = getCompanyAndStoreResponse
                self?.currentCompanyAndStore = CurrentCompanyAndStore(companyID: getCompanyAndStoreResponse.CompanyId ?? 0,
                                                                      storeID: getCompanyAndStoreResponse.StoreId ?? 0,
                                                                      sapCode: Int(getCompanyAndStoreResponse.SAPCode ?? "0") ?? 0,
                                                                      companyCode: getCompanyAndStoreResponse.CompanyCode ?? "0")
                self?.getCreditLimit()
                self?.getPurchaseRequest()
                self?.getAdvertisement()
                self?.dispatchGroup?.leave()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                self?.dispatchGroup?.leave()
            }
        } else {
            dispatchGroup?.enter()
            companyRepository.getCompanyAndStore {[weak self] getCompanyAndStoreResponse in
                self?.companyAndStoreModel = getCompanyAndStoreResponse
                self?.currentCompanyAndStore = CurrentCompanyAndStore(companyID: getCompanyAndStoreResponse.CompanyId ?? 0,
                                                                      storeID: getCompanyAndStoreResponse.StoreId ?? 0,
                                                                      sapCode: Int(getCompanyAndStoreResponse.SAPCode ?? "0") ?? 0,
                                                                      companyCode: getCompanyAndStoreResponse.CompanyCode ?? "0")
                self?.getPurchaseRequest()
                self?.getAdvertisement()
                self?.dispatchGroup?.leave()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.enter()
            sapRepository.getCreditLimit(SAPCode: Int(companyAndStoreModel?.SAPCode ?? "0") ?? 0) {[weak self] getCreditLimitResponse in
                self?.creditLimitModel = getCreditLimitResponse
                self?.dispatchGroup?.leave()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                self?.dispatchGroup?.leave()
            }
        }
        
        //        dispatchGroup?.enter()
        //        sapRepository.getCreditLimit(SAPCode: Int(companyAndStoreModel?.SAPCode ?? "0") ?? 0) {[weak self] getCreditLimitResponse in
        //            self?.creditLimitModel = getCreditLimitResponse
        //
        //            self?.dispatchGroup?.leave()
        //        } failure: {[weak self] errorDTO in
        //            self?.baseVMDelegate?.contentDidLoad()
        //
        //            self?.errorDTO = errorDTO
        //            self?.isPageContentFailed = true
        //
        //            self?.dispatchGroup?.leave()
        //        }
        
        //        dispatchGroup?.enter()
        //        reportRepository.getAllReports(SAPCode: Int(companyAndStoreModel?.SAPCode ?? "0") ?? 0) {[weak self] getAllReportsResponseDTO in
        //            self?.allReportsModel = getAllReportsResponseDTO
        //
        //            self?.dispatchGroup?.leave()
        //        } failure: {[weak self] errorDTO in
        //            self?.baseVMDelegate?.contentDidLoad()
        //            self?.errorDTO = errorDTO
        //            self?.isPageContentFailed = true
        //            self?.dispatchGroup?.leave()
        //        }
        
        //        dispatchGroup?.enter()
        //
        //        /// Dökümana göre anasayfada 5 tane talep görüntüleyebilmek için oluşturulmuş request modelidir. Parametreler bu şekilde gönderilmeli.
        //        let getAllPurchaseRequestDTO: GetAllPurchaseRequestDTO = GetAllPurchaseRequestDTO(Language: ServiceConfiguration.Language,
        //                                                                                          ProcessType: ServiceConfiguration.ProcessType,
        //                                                                                          RecordSizeFromPage: 5,
        //                                                                                          CurrentPage: 1,
        //                                                                                          SortColumn: "RequestDate",
        //                                                                                          SortColumnAscDesc: "Desc",
        //                                                                                          CompanyId: companyAndStoreModel?.CompanyId ?? 0,
        //                                                                                          StoreId: companyAndStoreModel?.StoreId ?? 0,
        //                                                                                          Filter: PurchaseRequestFilter(Name: "", FirstDate: "1900-01-01", LastDate: "1900-01-01", StateCodeValue: -1, TotalPrice: -1, TotalPriceOperator: ""))
        //
        //        purchaseRequestRepository.getAll(requestModel: getAllPurchaseRequestDTO) {[weak self] getAllPurchaseRequestResponse in
        //            self?.purchaseRequestResponseModel = getAllPurchaseRequestResponse
        //
        //            self?.dispatchGroup?.leave()
        //        } failure: {[weak self] errorDTO in
        //            self?.baseVMDelegate?.contentDidLoad()
        //            self?.errorDTO = errorDTO
        //            self?.isPageContentFailed = true
        //
        //            self?.dispatchGroup?.leave()
        //        }
        
        
        dispatchGroup?.notify(queue: .main, execute: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.baseVMDelegate?.contentDidLoad()
            
            if strongSelf.isPageContentFailed {
                strongSelf.delegate?.pageContentFailed(errorMessage: self?.errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
            else {
                if let companyAndStoreModel = strongSelf.companyAndStoreModel {
                    strongSelf.delegate?.getCompanyAndStoreSuccess(response: companyAndStoreModel)
                }
                
                if let creditLimitModel = strongSelf.creditLimitModel {
                    strongSelf.delegate?.getCreditLimitSuccess(response: creditLimitModel)
                }
                
                if let allReportsModel = strongSelf.allReportsModel {
                    strongSelf.delegate?.getAllReportsSuccess(response: allReportsModel)
                }
                
                if let purchaseRequestResponseModel = strongSelf.purchaseRequestResponseModel {
                    strongSelf.delegate?.purchaseRequestSuccess(response: purchaseRequestResponseModel)
                }
            }
        })
    }
    
    func getCompanyAndStore() {
        baseVMDelegate?.contentWillLoad()
        
        companyRepository.getCompanyAndStore {[weak self] getCompanyAndStoreResponse in
            self?.delegate?.getCompanyAndStoreSuccess(response: getCompanyAndStoreResponse)
            self?.companyAndStoreModel = getCompanyAndStoreResponse
            self?.currentCompanyAndStore = CurrentCompanyAndStore(companyID: getCompanyAndStoreResponse.CompanyId ?? 0,
                                                                  storeID: getCompanyAndStoreResponse.StoreId ?? 0,
                                                                  sapCode: Int(getCompanyAndStoreResponse.SAPCode ?? "0") ?? 0,
                                                                  companyCode: getCompanyAndStoreResponse.CompanyCode ?? "0")
            self?.getCreditLimit()
            self?.baseVMDelegate?.contentDidLoad()
        } failure: {[weak self] errorDTO in
            self?.delegate?.pageContentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func getCreditLimit() {
        baseVMDelegate?.contentWillLoad()
        
        guard let SAPCode = currentCompanyAndStore?.sapCode else {
            self.baseVMDelegate?.contentDidLoad()
            return
        }
        
        sapRepository.getCreditLimit(SAPCode: Int(SAPCode)) {[weak self] getCreditLimitResponse in
            self?.delegate?.getCreditLimitSuccess(response: getCreditLimitResponse)
            self?.creditLimitModel = getCreditLimitResponse
            self?.baseVMDelegate?.contentDidLoad()
        } failure: {[weak self] errorDTO in
            self?.delegate?.pageContentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    //    func getAllReports() {
    //        baseVMDelegate?.contentWillLoad()
    //
    //        guard let SAPCode = currentCompanyAndStore?.sapCode else {
    //            self.baseVMDelegate?.contentDidLoad()
    //            return
    //        }
    //
    //        reportRepository.getAllReports(SAPCode: Int(SAPCode)) {[weak self] getAllReportsResponseDTO in
    //            self?.allReportsModel = getAllReportsResponseDTO
    //            self?.delegate?.getAllReportsSuccess(response: getAllReportsResponseDTO)
    //            self?.baseVMDelegate?.contentDidLoad()
    //        } failure: {[weak self] errorDTO in
    ////            self?.delegate?.pageContentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
    //            self?.delegate?.pageContentFailed(errorMessage: errorDTO?.messageText ?? "klklklk")
    //            self?.baseVMDelegate?.contentDidLoad()
    //        }
    //    }
    
    func getPurchaseRequest() {
        baseVMDelegate?.contentWillLoad()
        guard let companyId = currentCompanyAndStore?.companyID,
              let storeId = currentCompanyAndStore?.storeID else {
            self.baseVMDelegate?.contentDidLoad()
            return
        }
        let getAllPurchaseRequestDTO: GetAllPurchaseRequestDTO = GetAllPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                          ProcessType: ServiceConfiguration.ProcessType,
                                                                                          RecordSizeFromPage: 5,
                                                                                          CurrentPage: 1,
                                                                                          SortColumn: "RequestDate",
                                                                                          SortColumnAscDesc: "Desc",
                                                                                          CompanyId: companyId,
                                                                                          StoreId: storeId,
                                                                                          Filter: PurchaseRequestFilter(Name: nil, FirstDate: nil, LastDate: nil, MaxPrice: nil, MinPrice: nil, StateCodeValue: nil))
        
        purchaseRequestRepository.getAll(requestModel: getAllPurchaseRequestDTO) {[weak self] getAllPurchaseRequestResponse in
            self?.purchaseRequestResponseModel = getAllPurchaseRequestResponse
            self?.delegate?.purchaseRequestSuccess(response: getAllPurchaseRequestResponse)
            self?.baseVMDelegate?.contentDidLoad()
        } failure: {[weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            self?.purchaseRequestResponseModel = GetAllPurchaseResponseDTO(info: nil, Data: nil)
        }
    }
    
    func getAdvertisement() {
        baseVMDelegate?.contentWillLoad()
        let advertisementRequestDTO: GetAdvertisementRequestDTO = GetAdvertisementRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
        advertisementRepository.getAdvertisement(getAdvertisementRequestDTO: advertisementRequestDTO) { [weak self] advertisementResponse in
            self?.advertisementModel = advertisementResponse.Advertisements
            self?.delegate?.advertisementRequestSuccess(response: advertisementResponse.Advertisements)
            self?.setFCMToken()
            self?.baseVMDelegate?.contentDidLoad()
        } failure: { [weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func setFCMToken() {
        if Constant.fcmToken != "" {
            notificationRepository.setFCMToken(FCMToken: Constant.fcmToken) { response in
                self.setPushNotification()
            } failure: { errorDTO in
#if DEBUG
                print("VEYSEL <<<< setFCM fail", errorDTO?.messageText)
#endif
            }
        }
    }
    
    private func setPushNotification() {
        notificationRepository.pushNotification { response in
#if DEBUG
            print("VEYSEL <<<< setPush success -> ", response.Message)
#endif
        } failure: { errorDTO in
#if DEBUG
            print("VEYSEL <<<< setPush fail -> ", errorDTO?.messageText)
#endif
        }
    }
}
