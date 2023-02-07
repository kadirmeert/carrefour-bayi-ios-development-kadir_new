//
//  PurchaseRequestService.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation
import Moya

enum PurchaseRequestService {
    case getAll(request: String)
    case getToken(request: String)
    case getPurchaseRequestDetail(request: String)
    case deletePurchaseRequest(request: String)
    case createPurchaseRequestGetSerialNumber(request: String)
    case createPurchaseRequest(request: String)
    case createPurchaseRequestDetail(request: String)
    case deletePurchaseRequestDetail(request: String)
    case updatePurchaseRequestDetail(request: String)
    case importPurchaseRequest(request: String, url: URL)
    case sendRequest(request: String)
}

extension PurchaseRequestService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getAll(_):
                return "/api/PurchaseRequest/GetAll"
            case .getToken(_):
                return "/api/PurchaseRequest/GetTokenForDownloadExcelTemplate"
            case .getPurchaseRequestDetail(_):
                return "/api/PurchaseRequest/GetPurchaseRequestDetails"
            case .deletePurchaseRequest(_):
                return "/api/PurchaseRequest/DeletePurchaseRequest"
            case .createPurchaseRequestGetSerialNumber(_):
                return "/api/PurchaseRequest/CreatePurchaseRequestGetSerialNumber"
            case .createPurchaseRequest(_):
                return "/api/PurchaseRequest/CreatePurchaseRequest"
            case .createPurchaseRequestDetail(_):
                return "/api/PurchaseRequest/CreatePurchaseRequestDetail"
            case .deletePurchaseRequestDetail(_):
                return "/api/PurchaseRequest/DeletePurchaseRequestDetail"
            case .updatePurchaseRequestDetail(_):
                return "/api/PurchaseRequest/UpdatePurchaseRequestDetail"
            case .importPurchaseRequest(_,_):
                return "/api/PurchaseRequest/ImportPurchaseRequestExcelFile"
            case .sendRequest(_):
                return "/api/PurchaseRequest/SendRequest"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
            case .getAll(let request),
                    .getToken(let request),
                    .getPurchaseRequestDetail(let request),
                    .deletePurchaseRequest(let request),
                    .createPurchaseRequestGetSerialNumber(let request),
                    .createPurchaseRequest(let request),
                    .createPurchaseRequestDetail(let request),
                    .deletePurchaseRequestDetail(let request),
                    .updatePurchaseRequestDetail(let request),
                    .sendRequest(let request):
                return .requestJSONEncodable(request)
        case .importPurchaseRequest(request: let request, url: let url):
            var formData = [MultipartFormData]()
            formData.append(MultipartFormData(provider: .file(url), name: "file"))
            formData.append(MultipartFormData.init(provider: .data(request.data(using: .utf8)!), name: "request"))
            return .uploadMultipart(formData)
             
        
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json",
                "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var errorDTOType: APIErrorDTOType {
        return .standard
    }
}

extension PurchaseRequestService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = PurchaseRequestService
    
#if MOCK_SERVICE
    static var provider: MoyaProvider<PurchaseRequestService> = MoyaProvider<PurchaseRequestService>(stubClosure: MoyaProvider<PurchaseRequestService>.immediatelyStub)
#else
    static var provider = MoyaProvider<PurchaseRequestService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
    //    static var provider: MoyaProvider<PurchaseRequestService> = MoyaProvider<PurchaseRequestService>(plugins: [Self.accessTokenPlugin])
#endif
}
