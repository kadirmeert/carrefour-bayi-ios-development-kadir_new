//
//  CityService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation
import Moya

enum CityService {
    case getCities(request: String)
    case getDistricts(request: String)
}

extension CityService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getCities(_):
            return "/api/City/GetCities"
        case .getDistricts(_):
            return "/api/City/GetDistricts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCities(_), .getDistricts(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCities(let request), .getDistricts(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCities(_), .getDistricts(_):
            return ["Content-type" : "application/json",
                    "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0",
                    "Authorization": "Bearer \(Constant.authDeviceToken)"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getCities(_), .getDistricts(_):
            return nil
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension CityService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = CityService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<CityService> = MoyaProvider<CityService>(stubClosure: MoyaProvider<CityService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<CityService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<CityService> = MoyaProvider<CityService>(plugins: [Self.accessTokenPlugin])
    #endif
}
