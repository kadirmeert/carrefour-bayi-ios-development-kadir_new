//
//  AccountService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation
import Alamofire
import Moya

enum AccountService {
    case login(request: String)
    case otpCheck(request: String)
    case resendCode(request: String)
    case confirmation(request: String)
    case authenticateDevice(request: String)
}

extension AccountService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .login(_):
            return "/api/Account/Login"
        case .otpCheck(_):
            return "/api/Account/OtpCheck"
        case .resendCode(_):
            return "/api/Account/ResendCode"
        case .confirmation(_):
            return "api/Account/Confirmation"
        case .authenticateDevice(_):
            return "api/Account/AuthenticateDevice"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .login(_), .otpCheck(_), .resendCode(_), .confirmation(_), .authenticateDevice(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
            case .login(let request), .otpCheck(let request), .resendCode(let request), .confirmation(let request),
                    .authenticateDevice(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(_), .otpCheck(_), .resendCode(_), .confirmation(_):
            return ["Content-type" : "application/json",
                    "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0",
                    "Authorization": "Bearer \(Constant.authDeviceToken)"]
            case .authenticateDevice(_):
                return ["Content-type" : "application/json",
                        "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
            case .login(_), .otpCheck(_), .resendCode(_), .confirmation(_), .authenticateDevice(_):
            return nil
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension AccountService: MoyaRequestWrapper, ConnectivityMiddleware, AccessTokenMiddleware {
    
    typealias Service = AccountService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<AccountService> = MoyaProvider<AccountService>(stubClosure: MoyaProvider<AccountService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<AccountService>(session: DefaultAlamofireSession.shared,
                                                       plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<AccountService> = MoyaProvider<AccountService>(plugins: [Self.accessTokenPlugin])
    #endif
}
