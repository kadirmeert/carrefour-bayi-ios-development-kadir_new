//
//  AccessTokenPlugin.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation
import Moya

struct AccessTokenPlugin: PluginType {
    typealias TokenClosure = (AuthorizationType) -> String
    typealias AppAccessTokenAuthorizable = AccessTokenAuthorizable

    /// A closure returning the access token to be applied in the header.
    let tokenClosure: TokenClosure

    /**
     Initialize a new `AccessTokenPlugin`.

     - parameters:
     - tokenClosure: A closure returning the token to be applied in the pattern `Authorization: <AuthorizationType> <token>`
     */
    init(tokenClosure: @escaping TokenClosure) {
        self.tokenClosure = tokenClosure
    }

    /**
     Prepare a request by adding an authorization header if necessary.

     - parameters:
     - request: The request to modify.
     - target: The target of the request.
     - returns: The modified `URLRequest`.
     */
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        guard let authorizable = target as? AppAccessTokenAuthorizable,
            let authorizationType = authorizable.authorizationType
            else { return request }
        
        if authorizationType == .basic {
            let authData = ("veysel.bozkurt" + ":" + "Kuka123.").data(using: .utf8)!.base64EncodedString()
//            headersWithAuth["Authorization"] = "Basic " + authData
            
            
//            let username = "veysel.bozkurt"
//            let password = "Kuka123*"
//            let loginString = "\(username):\(password)"
//            let loginData = loginString.data(using: String.Encoding.utf8)
//            let base64LoginString = loginData!.base64EncodedString()
            
            var request = request
//            request.httpMethod = "POST"
            request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")

            return request
        } else {
            var request = request

            let authValue = authorizationType.value + " " + tokenClosure(authorizationType)
            request.addValue(authValue, forHTTPHeaderField: "Authorization")

            return request
        }
    }
}
