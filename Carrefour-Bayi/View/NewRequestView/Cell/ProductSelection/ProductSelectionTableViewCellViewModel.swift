//
//  ProductSelectionTableViewCellViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 26.12.2022.
//

import Foundation

protocol ProductSelectionTableViewCellViewModelDelegate: AnyObject {
    func searchingByBarcodeSuccess()
    func searchingByStockSuccess()
    func pageContentFailed(message: String)
    func createPurchaseRequestDetailSuccess()
    func getPurchaseRequestDetailSuccess(modelData: [PurchaseRequestDetailData]?)
    
}


class ProductSelectionTableViewCellViewModel {
    
    
    weak var delegate: ProductSelectionTableViewCellViewModelDelegate?
    
    var productRepository: ProductRepository
    var purchaseRequestRepository: PurchaseRequestRepository
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    var barcodeProductModel: GetProductByBarcodeResponseDTO?
    var stockCodeProductModel: GetProductByStockCodeResponseDTO?
    
    var getPurchaseRequestDetailModel: GetPurchaseRequestDetailResponseDTO?
    
    var createPurchaseRequestDetailModel: CreatePurchaseDetailResponseDTO?
    
    
    init(productRepository: ProductRepository = RepositoryProvider.productRepository,purchaseRequestRepository: PurchaseRequestRepository = RepositoryProvider.purchaseRequestRepository ) {
        self.productRepository = productRepository
        self.purchaseRequestRepository = purchaseRequestRepository
    }
    
    
    
    func searchProductByBarcodeCode(barcodeCode: String) {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetProductByBarcodeRequestDTO = GetProductByBarcodeRequestDTO(storeSapCode: storeSAPCode,
                                                                                            Barcode: barcodeCode,
                                                                                            Language: ServiceConfiguration.Language,
                                                                                            ProcessType: ServiceConfiguration.ProcessType)
            
            productRepository.getProductByBarcode(requestModel: requestModel) { response in
                self.barcodeProductModel = response
                self.delegate?.searchingByBarcodeSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "Ürün Bulunamadı")
            }
        }
    }
    
    
    
    func searchProductByStockCode(stockCode: String) {
        if let storeSAPCode = currentCompanyAndStore?.sapCode {
            let requestModel: GetProductByStockCodeRequestDTO = GetProductByStockCodeRequestDTO(StoreSAPCode: storeSAPCode,
                                                                                                StockCode: stockCode,
                                                                                                Language: ServiceConfiguration.Language,
                                                                                                ProcessType: ServiceConfiguration.ProcessType)
            
            productRepository.getProductByStockCode(requestModel: requestModel) { response in
                self.stockCodeProductModel = response
                self.delegate?.searchingByStockSuccess()
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "Ürün Bulunamadı")
            }
        }
    }
    
    
    func createPurchaseRequestDetail(productId: String, PurchaseRequestId: Int, quantity: Int) {
        if let storeId = currentCompanyAndStore?.storeID {
            let requestModel: CreatePurchaseRequestDetailDTO = CreatePurchaseRequestDetailDTO(StoreId: storeId,
                                                                                              PurchaseRequestId: PurchaseRequestId,
                                                                                              ProductId: productId,
                                                                                              Quantity: quantity,
                                                                                              Language: ServiceConfiguration.Language,
                                                                                              ProcessType: ServiceConfiguration.ProcessType)
            purchaseRequestRepository.createPurchaseRequestDetail(requestModel: requestModel) { response in
                self.createPurchaseRequestDetailModel = response
                self.delegate?.createPurchaseRequestDetailSuccess()
            }  failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "Ürün Bulunamadı")
            }
        }
    }
    
    
    func getPurchaseRequestDetail(purchaseRequestId: Int) {
        if let storeCompanyID = currentCompanyAndStore?.companyID {
            let requestModel: GetPurchaseRequestDetailRequestDTO = GetPurchaseRequestDetailRequestDTO(CompanyId: storeCompanyID,
                                                                                                      Language: ServiceConfiguration.Language,
                                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                                      PurchaseId: purchaseRequestId)
            purchaseRequestRepository.getRequestDetail(requestModel: requestModel) { response in
                self.getPurchaseRequestDetailModel = response
                self.delegate?.getPurchaseRequestDetailSuccess(modelData: self.getPurchaseRequestDetailModel?.Data)
            } failure: { errorDTO in
                self.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "Ürün Bulunamadı")
            }
        }
    }
}
