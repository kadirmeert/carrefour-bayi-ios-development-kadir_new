//
//  NotificationService.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation
import Alamofire
import Moya

enum NotificationService {
    case getAllNotification(request: String)
    case notificationMarkAsRead(request: String)
    case pushNotification(request: String)
    case setFCMToken(request: String)
}

extension NotificationService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getAllNotification(_):
                return "/api/Notification/GetAllNotification"
            case .notificationMarkAsRead(_):
                return "/api/Notification/NotificationMarkAsRead"
            case .pushNotification(_):
                return "/api/Notification/PushNotification"
            case .setFCMToken(_):
                return "/api/Account/SetFCMToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAllNotification(_), .notificationMarkAsRead(_), .pushNotification(_), .setFCMToken(_):
                return .post
        }
    }
    
    var task: Task {
        switch self {
            case .getAllNotification(let request), .notificationMarkAsRead(let request), .pushNotification(let request), .setFCMToken(let request):
                return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        switch self {
            case .getAllNotification(_), .notificationMarkAsRead(_), .pushNotification(_), .setFCMToken(_):
                return ["Content-type" : "application/json",
                        "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
            case .getAllNotification(_), .notificationMarkAsRead(_), .pushNotification(_), .setFCMToken(_):
                return .bearer
        }
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}


extension NotificationService: MoyaRequestWrapper, ConnectivityMiddleware, AccessTokenMiddleware {
    
    typealias Service = NotificationService
    
    #if MOCK_SERVICE
    static var provider: MoyaProvider<NotificationService> = MoyaProvider<NotificationService>(stubClosure: MoyaProvider<NotificationService>.immediatelyStub)
    #else
    static var provider = MoyaProvider<NotificationService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
//    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(plugins: [Self.accessTokenPlugin])
    #endif
}
