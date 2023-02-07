//
//  AllOrderViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import Foundation

protocol AllOrderViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func pageContentFailed(message: String)
}

class AllOrderViewModel: BaseViewModel {
    
    weak var delegate: AllOrderViewModelDelegate?
    
    private var orderRepository: OrderRespository
    var ordersModel: GetOrdersResponseDTO?
    
    var getFilteredOrdersRequestDTO: GetOrdersRequestDTO?
    var getOrdersRequestDTO: GetOrdersRequestDTO?
    
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
    
    init(orderRepository: OrderRespository = RepositoryProvider.orderRepository) {
        self.orderRepository = orderRepository
    }
    
    override func viewWillAppear() {
        getAllOrders()
    }
    
    func getAllOrders() {
        if let companyID = currentCompanyAndStore?.companyID, let storeID = currentCompanyAndStore?.storeID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            getOrdersRequestDTO = GetOrdersRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, RecordSizeFromPage: 100, CurrentPage: currentPage, SortColumn: "Id", SortColumnAscDesc: "Desc", CompanyId: companyID, StoreId: storeID, Filter: OrderFilter(OrderNumber: nil, FirstDate: nil, LastDate: nil, OrderState: nil, MaxPrice: nil, MinPrice: nil))
            
            orderRepository.getOrders(getOrdersRequestDTO: getOrdersRequestDTO!) { [weak self] getOrdersResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.ordersModel = getOrdersResponse
                self?.delegate?.pageContentSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getMoreOrders(completion: @escaping () -> ()) {
        if getOrdersRequestDTO != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage += 1
            getOrdersRequestDTO?.CurrentPage = currentPage
            orderRepository.getOrders(getOrdersRequestDTO: getOrdersRequestDTO!) { [weak self] getOrdersResponse in
                self?.ordersModel?.Data! += getOrdersResponse.Data!
                self?.baseVMDelegate?.contentDidLoad()
                completion()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getFilteredOrders(orderNumber: String?, firstDate: String?, lastDate: String?, orderState: Int?,
                           maxPrice: Double?, minPrice: Double?, completion: @escaping () -> ()) {
        if let companyID = currentCompanyAndStore?.companyID, let storeID = currentCompanyAndStore?.storeID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage = 1
            getFilteredOrdersRequestDTO = GetOrdersRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, RecordSizeFromPage: 100, CurrentPage: currentPage, SortColumn: "Id", SortColumnAscDesc: "Desc", CompanyId: companyID, StoreId: storeID, Filter: OrderFilter(OrderNumber: orderNumber, FirstDate: firstDate, LastDate: lastDate, OrderState: orderState, MaxPrice: maxPrice, MinPrice: minPrice))
            orderRepository.getOrders(getOrdersRequestDTO: getFilteredOrdersRequestDTO!) { [weak self] getFilteredOrdersResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.ordersModel = getFilteredOrdersResponse
                self?.delegate?.pageContentSuccess()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getMoreFilteredOrders(completion: @escaping () -> ()) {
        if getFilteredOrdersRequestDTO != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.baseVMDelegate?.contentWillLoad()
            }
            currentPage += 1
            getFilteredOrdersRequestDTO?.CurrentPage = currentPage
            orderRepository.getOrders(getOrdersRequestDTO: getFilteredOrdersRequestDTO!) { [weak self] getFilteredOrdersResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.ordersModel?.Data! += getFilteredOrdersResponse.Data!
                completion()
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}

