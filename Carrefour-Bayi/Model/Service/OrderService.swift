//
//  OrderService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation
import Moya

enum OrderService {
    case getOrders(request: String)
    case getOrderDetails(request: String)
}

extension OrderService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getOrders(_):
            return "/api/Order/GetOrders"
        case .getOrderDetails(_):
            return "/api/Order/GetOrderDetails"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getOrders(_), .getOrderDetails(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getOrders(let request), .getOrderDetails(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getOrders(_), .getOrderDetails(_):
            return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getOrders(_), .getOrderDetails(_):
            return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension OrderService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = OrderService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(stubClosure: MoyaProvider<OrderService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<OrderService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(plugins: [Self.accessTokenPlugin])
    #endif
}
