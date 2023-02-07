//
//  RegionalManagerService.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation
import Moya

enum RegionalManagerService {
    case getRegionalManager(request: String)
    case deleteRegionalManager(request: String)
    case importRegionalManager(url: URL)
    case getTokenForDownloadExcelTemplate(request: String)
    case getTokenForRegionalManagersDownloadExcel(request: String)
}

extension RegionalManagerService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getRegionalManager(_):
                return "/api/RegionalManager/GetRegionalManagers"
            case .deleteRegionalManager(_):
                return "/api/RegionalManager/DeleteRegionalManager"
            case .importRegionalManager(_):
                return "/api/RegionalManager/ImportRegionalManagers"
            case .getTokenForDownloadExcelTemplate(_):
                return "/api/RegionalManager/GetTokenForDownloadExcelTemplate"
            case .getTokenForRegionalManagersDownloadExcel(_):
                return "/api/RegionalManager/GetTokenForRegionalManagersDownloadExcel"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getRegionalManager(_), .deleteRegionalManager(_), .importRegionalManager(_), .getTokenForDownloadExcelTemplate(_),
                    .getTokenForRegionalManagersDownloadExcel(_):
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getRegionalManager(let request), .deleteRegionalManager(let request), .getTokenForDownloadExcelTemplate(let request),
                    .getTokenForRegionalManagersDownloadExcel(let request):
                return .requestJSONEncodable(request)
            case .importRegionalManager(let url):
                var formData = [MultipartFormData]()
                formData.append(MultipartFormData(provider: .file(url), name: "ExcelFile"))
                return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .getRegionalManager(_), .deleteRegionalManager(_), .importRegionalManager(_), .getTokenForDownloadExcelTemplate(_),
                    .getTokenForRegionalManagersDownloadExcel(_):
                return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
            case .getRegionalManager(_), .deleteRegionalManager(_), .importRegionalManager(_), .getTokenForDownloadExcelTemplate(_),
                    .getTokenForRegionalManagersDownloadExcel(_):
                return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension RegionalManagerService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = RegionalManagerService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<RegionalManagerService> = MoyaProvider<RegionalManagerService>(stubClosure: MoyaProvider<RegionalManagerService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<RegionalManagerService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(plugins: [Self.accessTokenPlugin])
    #endif
}
