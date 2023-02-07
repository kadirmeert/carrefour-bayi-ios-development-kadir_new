//
//  ProductService.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation
import Moya

enum ProductService {
    case getAisles(request: String)
    case getMainProducts(request: String)
    case getMainGroups(request: String)
    case getMalGroups(request: String)
    case getProductsByProductName(request: String)
    case getProductByBarcode(request: String)
    case getProductByStockCode(request: String)
    case getProductsFiltered(request: String)
    case getProductInfoFromStocks(request: String)
    case updatePurchaseRequestDetail(request: String)
    case getPurchaseRequestDetails(request: String)
    case createPurchaseRequestDetail(request: String)
    case deletePurchaseRequestDetail(request: String)
}



extension ProductService: TargetType, AccessTokenAuthorizable, APIErrorDTOTypeProvider {
    
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
            case .getAisles(_):
                return "/api/Product/get-reyonlar"
            case .getMainProducts(_):
                return "/api/Product/get-anahamlar"
            case .getMainGroups(_):
                return "/api/Product/get-anagruplar"
            case .getMalGroups(_):
                return "/api/Product/get-malgruplar"
            case .getProductsByProductName(_):
                return "/api/Product/get-products-by-textin-name"
            case .getProductByBarcode(_):
                return "/api/Product/get-product-by-barcode"
            case .getProductByStockCode(_):
                return "/api/Product/get-product-by-barcode"
            case .getProductsFiltered(_):
                return "/api/Product/get-products-filtered"
            case .getProductInfoFromStocks(_):
                return "/api/Product/get-product-info-from-stoklar"
            case .updatePurchaseRequestDetail(_):
                return "/api/PurchaseRequest/UpdatePurchaseRequestDetail"
            case .getPurchaseRequestDetails(_):
                return "/api/PurchaseRequest/GetPurchaseRequestDetails"
            case .createPurchaseRequestDetail(_):
                return "/api/PurchaseRequest/CreatePurchaseRequestDetail"
            case .deletePurchaseRequestDetail(_):
                return "/api/PurchaseRequest/DeletePurchaseRequestDetail"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAisles(_),
                    .getMainProducts(_),
                    .getMainGroups(_),
                    .getMalGroups(_),
                    .getProductsByProductName(_),
                    .getProductByBarcode(_),
                    .getProductByStockCode(_),
                    .getProductsFiltered(_),
                    .getProductInfoFromStocks(_),
                    .updatePurchaseRequestDetail(_),
                    .getPurchaseRequestDetails(_),
                    .createPurchaseRequestDetail(_),
                    .deletePurchaseRequestDetail(_):
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getAisles(let request),
                    .getMainProducts(let request),
                    .getMainGroups(let request),
                    .getMalGroups(let request),
                    .getProductsByProductName(let request),
                    .getProductByBarcode(let request),
                    .getProductByStockCode(let request),
                    .getProductsFiltered(let request),
                    .getProductInfoFromStocks(let request),
                    .updatePurchaseRequestDetail(let request),
                    .getPurchaseRequestDetails(let request),
                    .createPurchaseRequestDetail(let request),
                    .deletePurchaseRequestDetail(let request):
                return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .getAisles(_),
                    .getMainProducts(_),
                    .getMainGroups(_),
                    .getMalGroups(_),
                    .getProductsByProductName(_),
                    .getProductByBarcode(_),
                    .getProductByStockCode(_),
                    .getProductsFiltered(_),
                    .getProductInfoFromStocks(_),
                    .updatePurchaseRequestDetail(_),
                    .getPurchaseRequestDetails(_),
                    .createPurchaseRequestDetail(_),
                    .deletePurchaseRequestDetail(_):
                return ["Content-type" : "application/json",
                        "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
            case .getAisles(_),
                    .getMainProducts(_),
                    .getMainGroups(_),
                    .getMalGroups(_),
                    .getProductsByProductName(_),
                    .getProductByBarcode(_),
                    .getProductByStockCode(_),
                    .getProductsFiltered(_),
                    .getProductInfoFromStocks(_),
                    .updatePurchaseRequestDetail(_),
                    .getPurchaseRequestDetails(_),
                    .createPurchaseRequestDetail(_),
                    .deletePurchaseRequestDetail(_):
                return .bearer
        }
    }
    
    
    var errorDTOType: APIErrorDTOType {
        switch self {
            case .getAisles(_),
                    .getMainProducts(_),
                    .getMainGroups(_),
                    .getMalGroups(_),
                    .getProductsByProductName(_),
                    .getProductByBarcode(_),
                    .getProductByStockCode(_),
                    .getProductsFiltered(_),
                    .getProductInfoFromStocks(_),
                    .updatePurchaseRequestDetail(_),
                    .getPurchaseRequestDetails(_),
                    .createPurchaseRequestDetail(_),
                    .deletePurchaseRequestDetail(_):
                return .standard
        }
    }
}




extension ProductService: MoyaRequestWrapper, AccessTokenMiddleware, ConnectivityMiddleware {
    
    typealias Service = ProductService
    
#if MOCK_SERVICE
    static var provider: MoyaProvider<ProductService> = MoyaProvider<ProductService>(stubClosure: MoyaProvider<ProductService>.immediatelyStub)
#else
    static var provider = MoyaProvider<ProductService>(session: DefaultAlamofireSession.shared, plugins: [Self.accessTokenPlugin])
    //    static var provider: MoyaProvider<OrderService> = MoyaProvider<OrderService>(plugins: [Self.accessTokenPlugin])
#endif
}
