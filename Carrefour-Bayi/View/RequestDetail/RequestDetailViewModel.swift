//
//  RequestDetailViewModel.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 12.11.2022.
//

import Foundation

protocol RequestDetailViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
    func deletePurchaseRequestSuccess()
}

class RequestDetailViewModel: BaseViewModel {
    weak var delegate: RequestDetailViewModelDelegate?
    
    private var purchaseRequestRepository: PurchaseRequestRepository
    var requestDetailModel: GetPurchaseRequestDetailResponseDTO?
    var requestData: PurchaseRequestData?
    
    init(purchaseRequestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository) {
        self.purchaseRequestRepository = purchaseRequestRepository
    }
    
    
    override func viewWillAppear() {
        getRequestDetail()
    }
    
    func getRequestDetail() {
        if let purchaseRequestID = requestData?.Id, let companyID = requestData?.CompanyId {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            let getPurchaseRequestDetailRequestDTO: GetPurchaseRequestDetailRequestDTO = GetPurchaseRequestDetailRequestDTO(CompanyId: companyID, Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, PurchaseId: purchaseRequestID)
            
            purchaseRequestRepository.getRequestDetail(requestModel: getPurchaseRequestDetailRequestDTO) { [weak self] getPurchaseRequestDetailResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.requestDetailModel = getPurchaseRequestDetailResponse
                self?.delegate?.pageContentSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }

        }
    }
//    func deletePurchaseRequest(id: Int?) {
//        purchaseRequestRepository.deletePurchaseRequest(purchaseRequestID: id ?? 0) { response in
//            self.delegate?.deletePurchaseRequestSuccess()
//            
//        } failure: { errorDTO in
//            self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
//            self.baseVMDelegate?.contentDidLoad()
//        }
//    }

}
