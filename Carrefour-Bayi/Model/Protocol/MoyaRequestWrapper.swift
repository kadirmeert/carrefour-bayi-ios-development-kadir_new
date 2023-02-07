//
//  MoyaRequestWrapper.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation
import Moya
import SwiftyJSON

protocol MoyaRequestWrapper {
    associatedtype Service: TargetType
    
    static var provider: MoyaProvider<Service> { get }
    func request<T:Decodable>(responseDTO: T.Type, completion: @escaping (T) -> Void, error errorBlock: @escaping (APIErrorMessageProvider?) -> Void)
    func request(completion: @escaping () -> Void, error errorBlock: @escaping (APIErrorMessageProvider?) -> Void)
}

extension MoyaRequestWrapper where Self: AccessTokenMiddleware, Self: TargetType, Self: ConnectivityMiddleware, Self: APIErrorDTOTypeProvider {
    ///It is the function that allows the service requests with a response body to be called.
    func request<T:Decodable>(responseDTO: T.Type, completion: @escaping (T) -> Void, error errorBlock: @escaping (APIErrorMessageProvider?) -> Void) {
        checkForInternetConnection { (connectedToInternet) in
            guard connectedToInternet else {
                errorBlock(InternetConnectionError())
                return
            }
            
            self.checkForAccessToken {
                Self.provider.request(self as! Self.Service) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            #if DEBUG
                            print("Moya request request & response")
                            print("API Request path: \(response.request?.url?.path ?? "")")
                            print("API Request body:\n \(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "")")
                            print("API Response code: \(response.response?.statusCode ?? -1)")
                            print("API Response body:\n \(String(data: response.data, encoding: .utf8) ?? "")")
                            #endif
                            
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            
                            if filteredResponse.statusCode == 200 {
                                let dataString = (String(data: response.data, encoding: .utf8) ?? "")
                                
                                CipherHelper.decryption(decryptedString: dataString) { decrtyptedData in
                                    #if DEBUG
                                    print(String(data: decrtyptedData, encoding: .utf8))
                                    #endif
                                    do {
                                        let decryptedJSON = try JSONDecoder().decode(T.self, from: decrtyptedData)
                                        completion(decryptedJSON)
                                    }
                                    catch {
                                        var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                                        errorDTO = APIErrorResponseDTO(Message: "JsonDecoderFailedMessage".localized)
                                        errorBlock(errorDTO)
                                    }
                                } failure: { errorResponse in
                                    errorBlock(errorResponse)
                                }
                            }
                            else {
                                var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                                errorDTO = APIErrorResponseDTO(Message: "Request error with status code: \(filteredResponse.statusCode)")
                                errorBlock(errorDTO)
                            }
                        }
                        catch {
                            var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                            
                            switch self.errorDTOType {
                            case .standard:
                                errorDTO = try? response.map(APIErrorResponseDTO.self)
                                
                                errorBlock(errorDTO)
                            }
                        }
                    case .failure(_):
                        errorBlock(nil)
                    }
                }
            } error: {_ in
                NotificationCenter.default.post(name: .userMustReLogin, object: nil)
            }
        }
    }
    
    ///It is a function that allows service requests that do not have a response body to be called.
    func request(completion: @escaping () -> Void, error errorBlock: @escaping (APIErrorMessageProvider?) -> Void) {
        checkForInternetConnection { (connectedToInternet) in
            guard connectedToInternet else {
                errorBlock(InternetConnectionError())
                return
            }
            
            self.checkForAccessToken {
                Self.provider.request(self as! Self.Service) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            #if DEBUG
                            print("Moya request request & response")
                            print("API Request path: \(response.request?.url?.path ?? "")")
                            print("API Request body:\n \(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "")")
                            print("API Response code: \(response.response?.statusCode ?? -1)")
                            print("API Response body:\n \(String(data: response.data, encoding: .utf8) ?? "")")
                            #endif
                            
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            
                            if filteredResponse.statusCode == 200 {
                                completion()
                            }
                            else {
                                var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                                errorDTO = APIErrorResponseDTO(Message: "Request error with status code: \(filteredResponse.statusCode)")
                                errorBlock(errorDTO)
                            }
                        }
                        catch {
                            var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                            
                            switch self.errorDTOType {
                            case .standard:
                                errorDTO = try? response.map(APIErrorResponseDTO.self)
                                
                                errorBlock(errorDTO)
                            }
                        }
                    case .failure(_):
                        errorBlock(nil)
                    }
                }
            } error: {_ in
                NotificationCenter.default.post(name: .userMustReLogin, object: nil)
            }
        }
    }
}
