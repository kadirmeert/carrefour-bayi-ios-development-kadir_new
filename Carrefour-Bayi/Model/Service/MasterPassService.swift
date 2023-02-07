//
//  MasterPassService.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation
import Moya

enum MasterPassService {
    case getToken(request: String)
    case getMasterPassInfo(request: String)
    case insertPurchase(request: String)
    case insertDirectPurchase(request: String)
    case insertRegisterPurchase(request: String)
    case commitPurchase(request: String)
    case insertResponse(request: String)
}


extension MasterPassService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getToken(_):
                return "/api/MasterPass/GetToken"
            case .getMasterPassInfo(_):
                return "/api/MasterPass/GetMasterPassInfo"
            case .insertPurchase(_):
                return "/api/MasterPass/InsertPurchase"
            case .insertDirectPurchase(_):
                return "/api/MasterPass/InsertDirectPurchase"
            case .insertRegisterPurchase(_):
                return "/api/MasterPass/InsertRegisterPurchase"
            case .commitPurchase(_):
                return "/api/MasterPass/CommitPurchase"
            case .insertResponse(_):
                return "/api/MasterPass/InsertResponse"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
            case .getToken(let request),
                    .getMasterPassInfo(let request),
                    .commitPurchase(let request),
                    .insertResponse(let request),
                    .insertPurchase(request: let request),
                    .insertDirectPurchase(request: let request),
                    .insertRegisterPurchase(request: let request):
                return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
    }
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}



extension MasterPassService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = MasterPassService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<MasterPassService> = MoyaProvider<MasterPassService>(stubClosure: MoyaProvider<MasterPassService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<MasterPassService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<CompanyService> = MoyaProvider<CompanyService>(plugins: [Self.accessTokenPlugin])
    #endif
    
}
