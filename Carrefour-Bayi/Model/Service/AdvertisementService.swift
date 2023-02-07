//
//  AdvertisementService.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.11.2022.
//

import Foundation
import Moya

enum AdvertisementService {
    case getAdvertisement(request: String)
}

extension AdvertisementService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getAdvertisement(_):
                return "/api/Advertisement/GetAdvertisements"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAdvertisement(_):
                return .post
        }
    }
    
    var task: Task {
        switch self {
            case .getAdvertisement(let request):
                return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAdvertisement(_):
            return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getAdvertisement(_):
            return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}


extension AdvertisementService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = AdvertisementService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<AdvertisementService> = MoyaProvider<AdvertisementService>(stubClosure: MoyaProvider<AdvertisementService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<AdvertisementService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(plugins: [Self.accessTokenPlugin])
    #endif
}
