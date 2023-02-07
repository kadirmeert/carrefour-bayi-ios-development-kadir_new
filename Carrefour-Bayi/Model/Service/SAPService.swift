//
//  SAPService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import Foundation
import Moya

enum SAPService {
    case getCreditLimit(request: String)
    case getStoreDashboardDetail(request: String)
    case getAccountingReport(request: String)
    case getAccountingReportExcel(request: String)
}

extension SAPService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getCreditLimit(_):
            return "/api/SAP/GetCreditLimit"
        case .getStoreDashboardDetail(_):
            return "/api/SAP/GetStoreDashboardDetail"
        case .getAccountingReport(_):
            return "/api/SAP/GetCariHareketRaporu"
            case .getAccountingReportExcel(_):
                return "/api/SAP/GetCariHareketRaporuExcel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCreditLimit(_), .getStoreDashboardDetail(_),
                    .getAccountingReport(_), .getAccountingReportExcel(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCreditLimit(let request), .getStoreDashboardDetail(let request),
                    .getAccountingReport(let request), .getAccountingReportExcel(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCreditLimit(_), .getStoreDashboardDetail(_),
                    .getAccountingReport(_), .getAccountingReportExcel(_):
            return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getCreditLimit(_), .getStoreDashboardDetail(_),
                    .getAccountingReport(_), .getAccountingReportExcel(_):
            return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension SAPService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = SAPService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<SAPService> = MoyaProvider<SAPService>(stubClosure: MoyaProvider<SAPService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<SAPService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<SAPService> = MoyaProvider<SAPService>(plugins: [Self.accessTokenPlugin])
    #endif
}
