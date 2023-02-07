//
//  OrderDetailViewModel.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 11.11.2022.
//

import Foundation

protocol OrderDetailViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
}

class OrderDetailViewModel: BaseViewModel {
    weak var delegate: OrderDetailViewModelDelegate?
    
    private var orderRepository: OrderRespository
    var orderDetailModel: GetOrderDetailResponseDTO?
    var orderData: OrderData?
    
    
    init(orderRepository: OrderRespository = RepositoryProvider.orderRepository) {
        self.orderRepository = orderRepository
    }
    
    
    override func viewWillAppear() {
        getOrderDetail()
    }
    
    func getOrderDetail() {
        if let orderID = orderData?.Id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            let getOrderDetailRequestDTO: GetOrderDetailRequestDTO = GetOrderDetailRequestDTO(OrderId: orderID, Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
            orderRepository.getOrderDetails(getOrderDetailRequestDTO: getOrderDetailRequestDTO) { [weak self] getOrderDetailResponseDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.orderDetailModel = getOrderDetailResponseDTO
                self?.delegate?.pageContentSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}
