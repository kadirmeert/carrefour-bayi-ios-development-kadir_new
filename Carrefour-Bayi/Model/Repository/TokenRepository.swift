//
//  TokenRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation
import KeychainAccess

protocol TokenRepository {
    func accessToken() -> String?
    func isAccessTokenExpired() -> Bool
    func saveTokenInfo(provider: Oauth2TokenProvider, userName: String, password: String, userData: UserData?)
    func refreshToken(completion: @escaping () -> Void, error: @escaping (APIErrorMessageProvider?) -> Void)
    func getUserData() -> UserData?
    func getUserPhoneNumber() -> String?
    func saveUserPhoneNumber(phoneNumber: String)
    func deleteToken()
}

class DefaultTokenRepository: TokenRepository {
    private let keychain = Keychain(service: "com.carrefoursa.Carrefour-Bayi").accessibility(.afterFirstUnlock).synchronizable(true)
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let accessTokenExpireDateKey = "accessTokenExpireDate"
    private let refreshTokenExpireDateKey = "refreshTokenExpireDate"
    
    private let carrefourUsernameKey = "carrefourUsernameKey"
    private let carrefourPasswordKey = "carrefourPasswordKey"
    private let carrefourPhoneNumberKey = "carrefourPhoneNumberKey"
    
    private let userDataKey = "userDataKey"
    
    func accessToken() -> String? {
        return keychain[string: "\(accessTokenKey)"]
    }
    
    private func refreshToken() -> String? {
        return keychain[string: "\(refreshTokenKey)"]
    }
    
    func getUserPhoneNumber() -> String? {
        if let userPhoneNumber = keychain[string: "\(carrefourPhoneNumberKey)"] {
            return userPhoneNumber
        }
        return nil
    }
    
    func getUserData() -> UserData? {
        if let jsonString = keychain[string: "\(userDataKey)"] {
            let jsonData = Data(jsonString.utf8)
            let decoder = JSONDecoder()

            do {
                let userData = try decoder.decode(UserData.self, from: jsonData)
                return userData
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return nil
    }
    
    func isAccessTokenExpired() -> Bool {
        let expireDate = TimeInterval(keychain[string: "\(accessTokenExpireDateKey)"] ?? "0") ?? 0
        let now = Date().timeIntervalSince1970
        
        return now > expireDate
    }
    
    func saveUserPhoneNumber(phoneNumber: String) {
        keychain[string: "\(carrefourPhoneNumberKey)"] = phoneNumber
    }
    
    func saveTokenInfo(provider: Oauth2TokenProvider, userName: String, password: String, userData: UserData? = nil) {
        let isoDateString = provider.ExpireDate ?? "0"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: isoDateString)
        
        let expireDate = date?.timeIntervalSince1970 ?? 0
        
        keychain[string: "\(accessTokenExpireDateKey)"] = String(expireDate)
        keychain[string: "\(accessTokenKey)"] = provider.Jwt
        keychain[string: "\(refreshTokenKey)"] = provider.RefreshToken
        keychain[string: "\(refreshTokenExpireDateKey)"] = provider.RefreshTokenEndDate
        
        if !userName.isEmpty && !password.isEmpty {
            keychain[string: "\(carrefourUsernameKey)"] = userName
            keychain[string: "\(carrefourPasswordKey)"] = password
        }
        
        if let jsonData = try? JSONEncoder().encode(userData), let jsonString = String(data: jsonData, encoding: .utf8) {
            keychain[string: userDataKey] = jsonString
        }
    }
    
    func deleteToken() {
        try? keychain.remove("\(accessTokenKey)")
        try? keychain.remove("\(accessTokenExpireDateKey)")
        try? keychain.remove("\(refreshTokenKey)")
        try? keychain.remove("\(refreshTokenExpireDateKey)")
        try? keychain.remove("\(carrefourUsernameKey)")
        try? keychain.remove("\(carrefourPasswordKey)")
        try? keychain.remove("\(carrefourPhoneNumberKey)")
        try? keychain.remove("\(userDataKey)")
    }
    
    func refreshToken(completion: @escaping () -> Void, error: @escaping (APIErrorMessageProvider?) -> Void) {
        
        deleteToken()
        error(nil)
        
//        guard let userName = keychain[string: "\(carrefourUsernameKey)"], let password = keychain[string: "\(carrefourPasswordKey)"] else {
//            deleteToken()
//            error(nil)
//            return
//        }
        
        
//        let tokenRequestDTO: TokenRequestDTO = TokenRequestDTO(Username: userName, Password: password)
//
//        CipherHelper.encryption(requestDTO: tokenRequestDTO) { encryptedString in
//            AccountService.login(request: encryptedString).request(responseDTO: TokenResponseDTO.self) {[weak self] loginResponse in
//                if let success = loginResponse.Success, success {
//                    let tokenProvider: TokenResponseDTO = TokenResponseDTO(Jwt: loginResponse.Jwt, ExpireDate: loginResponse.ExpireDate, RefreshToken: loginResponse.RefreshToken, RefreshTokenEndDate: loginResponse.RefreshTokenEndDate)
//
//                    self?.saveTokenInfo(provider: tokenProvider, userName: userName, password: password)
//
//                    completion()
//                }
//                else {
//                    self?.deleteToken()
//                    error(nil)
//                    return
//                }
//            } error: { errorDTO in
//                error(errorDTO)
//            }
//
//        } failure: { errorDTO in
//            error(errorDTO)
//        }
    }
}

class MockTokenRepository: TokenRepository {
    func getUserPhoneNumber() -> String? {
        return nil
    }
    
    func saveUserPhoneNumber(phoneNumber: String) {
        
    }
    
    func deleteToken() {
        
    }
    
    func getUserData() -> UserData? {
        return nil
    }
    
    func saveTokenInfo(provider: Oauth2TokenProvider, userName: String, password: String, userData: UserData? = nil) {
        
    }
    
    func refreshToken(completion: @escaping () -> Void, error: @escaping (APIErrorMessageProvider?) -> Void) {
        
    }
    
    func isAccessTokenExpired() -> Bool {
        return true
    }
    
    func accessToken() -> String? {
        return ""
    }
}
