//
//  OrderRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation

protocol OrderRespository {
    func getOrders(getOrdersRequestDTO: GetOrdersRequestDTO, completion: @escaping(GetOrdersResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
    func getOrderDetails(getOrderDetailRequestDTO: GetOrderDetailRequestDTO, completion: @escaping(GetOrderDetailResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void)
}



class DefaultOrderRepository: OrderRespository {
    func getOrders(getOrdersRequestDTO: GetOrdersRequestDTO, completion: @escaping (GetOrdersResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: getOrdersRequestDTO) { encryptedString in
            OrderService.getOrders(request: encryptedString).request(responseDTO: GetOrdersResponseDTO.self) { getOrdersResponse in
                if let success = getOrdersResponse.Success, success {
                    completion(getOrdersResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getOrdersResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    
    func getOrderDetails(getOrderDetailRequestDTO: GetOrderDetailRequestDTO, completion: @escaping (GetOrderDetailResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        CipherHelper.encryption(requestDTO: getOrderDetailRequestDTO) { encryptedString in
            OrderService.getOrderDetails(request: encryptedString).request(responseDTO: GetOrderDetailResponseDTO.self) { getOrderDetailResponse in
                if let success = getOrderDetailResponse.Success, success {
                    completion(getOrderDetailResponse)
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: (getOrderDetailResponse).Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }

        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
}



class MockOrderRepository: OrderRespository {
    func getOrders(getOrdersRequestDTO: GetOrdersRequestDTO, completion: @escaping (GetOrdersResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(GetOrdersResponseDTO(info: OrderInfo(Count: 0, Pages: 0, Next: "string", Prev: "string"), Data: [OrderData(Id: 0, InsertDate: "2022-08-10", Name: "string", CompanyId: 0, StoreId: 0, OrderDate: "2022-08-10", StateCode: 0, TotalPrice: 0, UpdatedByUserId: 0, UpdatedDate: "2022-08-10", IsDeleted: true, StateCodeValue: "string", TotalRowCount: 0)]))
        }
    }
    
    
    func getOrderDetails(getOrderDetailRequestDTO: GetOrderDetailRequestDTO, completion: @escaping (GetOrderDetailResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
}
