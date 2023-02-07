//
//  AccountingViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import Foundation

protocol AccountingViewModelDelegate: BaseViewModelDelegate {
    func storeDashboardDetailSuccess(response: GetStoreDashboardDetailResponseDTO)
    func creditLimitSuccess(response: GetCreditLimitResponseDTO)
    func pageContentFailed(message: String)
}

class AccountingViewModel: BaseViewModel {
    weak var delegate: AccountingViewModelDelegate?
    
    private var sapRepository: SAPRepository
    
    private var dispatchGroup: DispatchGroup?
    private var isPageContentFailed: Bool
    private var errorDTO: APIErrorMessageProvider?
    
    var SAPCode: String?
    var storeDashboardDetail: GetStoreDashboardDetailResponseDTO?
    var creditLimit: GetCreditLimitResponseDTO?
    
    init(sapRepository: SAPRepository = RepositoryProvider.sapRepository) {
        self.sapRepository = sapRepository
        
        isPageContentFailed = false
    }
    
//    override func viewDidAppear() {
//
//    }
    
    override func viewDidLoad() {
        if SAPCode != nil {
            getStoreDashboardDetail()
        }
    }
    
    func getStoreDashboardDetail() {
        if let SAPCode = SAPCode {
            dispatchGroup = DispatchGroup()
            
            isPageContentFailed = false
            
            dispatchGroup?.enter()
            
            baseVMDelegate?.contentWillLoad()
            sapRepository.getStoreDashboardDetail(SAPCode: SAPCode) {[weak self] getStoreDashboardDetailResponse in
                self?.storeDashboardDetail = getStoreDashboardDetailResponse
                self?.dispatchGroup?.leave()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.enter()
            sapRepository.getCreditLimit(SAPCode: Int(SAPCode) ?? 0) {[weak self] getCreditLimitResponse in
                self?.creditLimit = getCreditLimitResponse
                
                self?.dispatchGroup?.leave()
            } failure: {[weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.notify(queue: .main, execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                if strongSelf.isPageContentFailed {
                    strongSelf.delegate?.pageContentFailed(message: self?.errorDTO?.messageText ?? "generalErrorMessage".localized)
                }
                else {
                    strongSelf.baseVMDelegate?.contentDidLoad()
                    
                    if let storeDashboardDetail = strongSelf.storeDashboardDetail {
                        strongSelf.delegate?.storeDashboardDetailSuccess(response: storeDashboardDetail)
                    }
                    
                    if let creditLimit = strongSelf.creditLimit {
                        strongSelf.delegate?.creditLimitSuccess(response: creditLimit)
                    }
                }
            })
        }
    }
}
