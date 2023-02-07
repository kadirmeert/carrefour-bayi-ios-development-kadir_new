//
//  GetRequestTableViewCellViewModel.swift
//  Carrefour-Bayi
//
//  Created by Mert on 19.01.2023.
//

import Foundation

protocol GetRequestTableViewCellViewModelDelegate: AnyObject {
    func deletePurchaseRequestDetailSuccess()
    func pageContentFailed(message: String)
    func updatePurchaseRequestDetailSuccess()
    
}

class GetRequestTableViewCellViewModel {
    
    var delegate: GetRequestTableViewCellViewModelDelegate?
    
    var purchaseRequestRepository: PurchaseRequestRepository
   
    var deletePurchaseRequestDetailModel: DeletePurchaseRequestDetailResponseDTO?
    
    var updatePurchaseRequestDetailModel: UpdatePurchaseResponseDTO?
    
    init(purchaseRequestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository ) {
        self.purchaseRequestRepository = purchaseRequestRepository
    }
    
    
    func deletePurchaseRequestDetail(id: Int) {
        
        purchaseRequestRepository.deletePurchaseRequestDetail(PurchaseRequestDetailId: id) { response in
            
            self.deletePurchaseRequestDetailModel = response
            self.delegate?.deletePurchaseRequestDetailSuccess()
            
        } failure: { errorDTO in
            self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
        
    }
    func updatePurchaseRequestDetail(quantity: Int, id: Int, productId: Int) {
        let requestModel : UpdatePurchaseRequestDetailDTO = UpdatePurchaseRequestDetailDTO(Quantity: quantity,
                                                                                           PurchaseRequestDetailId: id ,
                                                                                           StoreId: 25,
                                                                                           ProductId: String(describing: productId),
                                                                                           Language: ServiceConfiguration.Language,
                                                                                           ProcessType: ServiceConfiguration.ProcessType)
        
        purchaseRequestRepository.updatePurchaseRequestDetail(requestModel: requestModel) { response in
            
            self.updatePurchaseRequestDetailModel = response
            self.delegate?.updatePurchaseRequestDetailSuccess()
            
            
        } failure: { errorDTO in
            self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
    }
    
}

