//
//  NewRequestViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 9.12.2022.
//

import Foundation

protocol NewRequestViewModelDelegate: BaseViewModelDelegate {
    func getSerialNumberSuccess()
    func createPurchaseRequestSuccess()
    func getAislesSuccess()
    func getProductsFilteredSuccess()
    func pageContentFailed(message: String)
    func pageContentInfoFailed(message: String)
    func getProductInfoFromStocksSuccess()
    func sendRequestSuccess()
}


class NewRequestViewModel: BaseViewModel {
    
    weak var delegate: NewRequestViewModelDelegate?
    private var purchaseRequestRepository: PurchaseRequestRepository
    private var productRepository: ProductRepository
    
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    //    MARK: - response models
    var getSerialNumberResponseModel: CreatePurchaseRequestGetSerialNumberResponseDTO?
    var createPurchaseResponseModel: CreatePurchaseResponseDTO?
    var aislesModel: [AisleModel]?
    var getProductsByProductNameModel: GetProductsFilteredResponseDTO?
    var getProductInfoFromStocksModel: GetProductInfoFromStocksResponseDTO?
    
    
    init(purchaseRequestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository,
         productRepository: ProductRepository = RepositoryProvider.productRepository) {
        self.purchaseRequestRepository = purchaseRequestRepository
        self.productRepository = productRepository
    }
    
    override func viewWillAppear() {
        getSerialNumber()
    }
    
    
    func getSerialNumber() {
        if let storeID = currentCompanyAndStore?.storeID {
            self.baseVMDelegate?.contentWillLoad()
            purchaseRequestRepository.createPurchaseRequestGetSerialNumber(storeID: storeID) { [weak self] getSerialNumberResponse in
                self?.baseVMDelegate?.contentDidLoad()
                if let _ = getSerialNumberResponse.SerialNumber {
                    self?.getSerialNumberResponseModel = getSerialNumberResponse
                    self?.delegate?.getSerialNumberSuccess()
                }
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    
    func createPurchaseRequest(requestNo: String, requestDate: String) {
        self.baseVMDelegate?.contentWillLoad()
        if let companyID = currentCompanyAndStore?.companyID,
           let storeID = currentCompanyAndStore?.storeID {
            let requestModel: CreatePurchaseRequestDTO = CreatePurchaseRequestDTO(CompanyId: companyID, StoreId: storeID,
                                                                                  PurchaseRequestNo: requestNo,
                                                                                  PurchaseRequestDate: requestDate,
                                                                                  Language: ServiceConfiguration.Language,
                                                                                  ProcessType: ServiceConfiguration.ProcessType)
            purchaseRequestRepository.createPurchaseRequest(requestModel: requestModel) { [weak self] createPurchaseRequestResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.createPurchaseResponseModel = createPurchaseRequestResponse
                self?.delegate?.createPurchaseRequestSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
        
    }
    
    
    func getAisles() {
        self.baseVMDelegate?.contentWillLoad()
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            productRepository.getAisles(storeSAPCode: storeSAPCode, text: "") { [weak self] getAislesResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.aislesModel = getAislesResponse.getReyonlarDtos
                self?.delegate?.getAislesSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    
    func getProductsFiltered(requestModel: GetProductsFilteredRequestDTO) {
        self.baseVMDelegate?.contentWillLoad()
        productRepository.getProductsFiltered(requestModel: requestModel) { [weak self] getProductByProductResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.getProductsByProductNameModel = getProductByProductResponse
            self?.delegate?.getProductsFilteredSuccess()
            
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    
    func getProductInfoFromStocks(requestModel: GetProductInfoFromStocksRequestDTO) {
        self.baseVMDelegate?.contentWillLoad()
        productRepository.getProductInfoFromStocks(requestModel: requestModel) { [weak self] getProductInfoResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.getProductInfoFromStocksModel = getProductInfoResponse
            self?.delegate?.getProductInfoFromStocksSuccess()
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentInfoFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    
    func sendRequest(purchaseRequestId: Int?) {
        self.baseVMDelegate?.contentWillLoad()
        let requestModel: SendPurchaseRequestDTO = SendPurchaseRequestDTO(PurchaseRequestId: purchaseRequestId ?? 0,
                                                                          Language: ServiceConfiguration.Language,
                                                                          ProcessType: ServiceConfiguration.ProcessType)
        purchaseRequestRepository.sendRequest(requestModel: requestModel) { [weak self] sendRequestResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.sendRequestSuccess()
            print(sendRequestResponse)
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
}


