//
//  CompanyService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation
import Moya

enum CompanyService {
    case getCompanyAndStore(request: String)
    case getCompanies(request: String)
    case getStore(request: String)
    case getCompanyAndStoreList(request: String)
}

extension CompanyService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getCompanyAndStore(_):
            return "/api/Company/GetCompanyAndStore"
        case .getCompanies(_):
            return "/api/Company/GetCompanies"
        case .getStore(_):
            return "/api/Company/GetStore"
        case .getCompanyAndStoreList(_):
            return "/api/Company/GetCompanyAndStoreList"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCompanyAndStore(_), .getCompanies(_), .getStore(_), .getCompanyAndStoreList(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCompanyAndStore(let request), .getCompanies(let request), .getStore(let request), .getCompanyAndStoreList(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCompanyAndStore(_), .getCompanies(_), .getStore(_), .getCompanyAndStoreList(_):
            return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getCompanyAndStore(_), .getCompanies(_), .getStore(_), .getCompanyAndStoreList(_):
            return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension CompanyService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = CompanyService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<CityService> = MoyaProvider<CompanyService>(stubClosure: MoyaProvider<CompanyService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<CompanyService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<CompanyService> = MoyaProvider<CompanyService>(plugins: [Self.accessTokenPlugin])
    #endif
}
