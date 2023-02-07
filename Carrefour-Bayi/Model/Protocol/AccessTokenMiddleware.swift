//
//  AccessTokenMiddleware.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation
import Moya

protocol AccessTokenMiddleware {
    static var accessTokenPlugin: AccessTokenPlugin { get }
    func checkForAccessToken(completion: @escaping () -> Void, error: @escaping (APIErrorMessageProvider?) -> Void)
}

extension AccessTokenMiddleware where Self: AccessTokenAuthorizable {
    static var accessTokenPlugin: AccessTokenPlugin {
        get  {
            AccessTokenPlugin { _ in
                return RepositoryProvider.tokenRepository.accessToken() ?? ""
            }
        }
    }
    
    func checkForAccessToken(completion: @escaping () -> Void, error: @escaping (APIErrorMessageProvider?) -> Void) {
        guard self.authorizationType != nil else {
            completion()
            return
        }
        
        let tokenRepository = RepositoryProvider.tokenRepository
        
        guard !tokenRepository.isAccessTokenExpired() else {
            tokenRepository.refreshToken(completion: {
                completion()
            }) { (errorDTO) in
                error(errorDTO)
            }
            return
        }
        completion()
    }
}
