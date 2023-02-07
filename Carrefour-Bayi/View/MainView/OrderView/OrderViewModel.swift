//
//  OrderViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 18.08.2022.
//

import Foundation

protocol OrderViewModelDelegate: BaseViewModelDelegate {
    func getOrdersSuccess()
    func pageContentFailed(message: String)
}

class OrderViewModel: BaseViewModel {
    weak var delegate: OrderViewModelDelegate?
    
    private var orderRepository: OrderRespository
    
    var ordersModel: GetOrdersResponseDTO?
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    init(orderRepository: OrderRespository = RepositoryProvider.orderRepository) {
        self.orderRepository = orderRepository
    }
    
    override func viewWillAppear() {
        getOrders()
    }
    
    func getOrders() {
        if let currentCompanyAndStore = currentCompanyAndStore {
            baseVMDelegate?.contentWillLoad()
            
            let getOrdersRequestDTO: GetOrdersRequestDTO = GetOrdersRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, RecordSizeFromPage: 3, CurrentPage: 1, SortColumn: "Id", SortColumnAscDesc: "Desc", CompanyId: currentCompanyAndStore.companyID , StoreId: currentCompanyAndStore.storeID , Filter: OrderFilter(OrderNumber: nil, FirstDate: nil, LastDate: nil, OrderState: nil, MaxPrice: nil, MinPrice: nil))
            
            orderRepository.getOrders(getOrdersRequestDTO: getOrdersRequestDTO) {[weak self] getOrdersResponse in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.ordersModel = getOrdersResponse
                self?.delegate?.getOrdersSuccess()
            } failure: {[weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}
