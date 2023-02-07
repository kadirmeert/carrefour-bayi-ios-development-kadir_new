//
//  ReportService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation
import Moya

enum ReportService {
    case getAllReports(request: String)
}

extension ReportService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getAllReports(_):
            return "/api/Report/GetAll"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllReports(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getAllReports(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAllReports(_):
            return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getAllReports(_):
                return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    } 
}

extension ReportService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = ReportService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<ReportService> = MoyaProvider<ReportService>(stubClosure: MoyaProvider<ReportService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<ReportService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<ReportService> = MoyaProvider<ReportService>(plugins: [Self.accessTokenPlugin])
    #endif
}
