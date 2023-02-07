//
//  UserRepository.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation
import JWTDecode
import KeychainAccess

protocol AccountRepository {
    var isUserLoggedIn: Bool { get }
    var userId: String? { get }
    
    func login(userName: String, password: String, completion: @escaping(LoginResponseDTO) -> Void,
               failure: @escaping(APIErrorMessageProvider?) -> Void)
    func otpCheck(userName: String, code: String, completion: @escaping(OTPCheckResponseDTO) -> Void,
                  failure: @escaping(APIErrorMessageProvider?) -> Void)
    func resendCode(userName: String, phoneNumber: String, completion: @escaping(ResendCodeResponseDTO) -> Void,
                    failure: @escaping(APIErrorMessageProvider?) -> Void)
    func confirmation(confirmationRequestDTO: ConfirmationRequestDTO, completion: @escaping(ConfirmationResponseDTO) -> Void,
                      failure: @escaping(APIErrorMessageProvider?) -> Void)
    func authenticateDevice()
    func logout()
}

class DefaultAccountRepository: AccountRepository {
    private var tokenRepository: TokenRepository
    
    var userId: String? {
        get {
            guard let token = tokenRepository.accessToken(), let jwt = try? decode(jwt: token) else {
                return nil
            }
            return jwt.claim(name: "uid").string
        }
    }
    
    var isUserLoggedIn: Bool {
        get {
            return tokenRepository.accessToken() != nil
        }
    }
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func login(userName: String, password: String, completion: @escaping (LoginResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let loginRequestDTO: LoginRequestDTO = LoginRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, Username: userName, Password: password)
        
        CipherHelper.encryption(requestDTO: loginRequestDTO) { encryptedString in
            AccountService.login(request: encryptedString).request(responseDTO: LoginResponseDTO.self) {[weak self] loginResponse in
                if let success = loginResponse.Success, success {
                    let tokenProvider: TokenResponseDTO = TokenResponseDTO(Jwt: loginResponse.Jwt, ExpireDate: loginResponse.ExpireDate, RefreshToken: loginResponse.RefreshToken, RefreshTokenEndDate: loginResponse.RefreshTokenEndDate)
                    
                    self?.tokenRepository.saveTokenInfo(provider: tokenProvider, userName: userName, password: password, userData: loginResponse.UserData)
                    
                    print("loginResponse: \(loginResponse)")
                    completion(loginResponse)
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: loginResponse.Message)

                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func otpCheck(userName: String, code: String, completion: @escaping (OTPCheckResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let otpCheckRequestDTO: OTPCheckRequestDTO = OTPCheckRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, Username: userName, Code: code)
        
        CipherHelper.encryption(requestDTO: otpCheckRequestDTO) { encryptedString in
            AccountService.otpCheck(request: encryptedString).request(responseDTO: OTPCheckResponseDTO.self) { otpCheckResponse in
                if let success = otpCheckResponse.Success, success {
                    let tokenProvider: TokenResponseDTO = TokenResponseDTO(Jwt: otpCheckResponse.Jwt, ExpireDate: otpCheckResponse.ExpireDate, RefreshToken: otpCheckResponse.RefreshToken, RefreshTokenEndDate: otpCheckResponse.RefreshTokenEndDate)
                    self.tokenRepository.saveTokenInfo(provider: tokenProvider, userName: "", password: "", userData: otpCheckResponse.UserData)
                    
                    completion(otpCheckResponse)
                    print("otpCheckResponse: \(otpCheckResponse)")
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: otpCheckResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func resendCode(userName: String, phoneNumber: String, completion: @escaping (ResendCodeResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        let resendCodeRequestDTO: ResendCodeRequestDTO = ResendCodeRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, Username: userName, PhoneNumber: phoneNumber)
        
        CipherHelper.encryption(requestDTO: resendCodeRequestDTO) { encryptedString in
            AccountService.resendCode(request: encryptedString).request(responseDTO: ResendCodeResponseDTO.self) { resendCodeResponse in
                if let success = resendCodeResponse.Success, success {
                    completion(resendCodeResponse)
                    print("resendCodeResponse: \(resendCodeResponse)")
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: resendCodeResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func confirmation(confirmationRequestDTO: ConfirmationRequestDTO, completion: @escaping (ConfirmationResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void) {
        
        CipherHelper.encryption(requestDTO: confirmationRequestDTO) { encryptedString in
            AccountService.confirmation(request: encryptedString).request(responseDTO: ConfirmationResponseDTO.self) { confirmationResponse in
                if let success = confirmationResponse.Success, success {
                    let tokenProvider: TokenResponseDTO = TokenResponseDTO(Jwt: confirmationResponse.Jwt, ExpireDate: confirmationResponse.ExpireDate, RefreshToken: confirmationResponse.RefreshToken, RefreshTokenEndDate: confirmationResponse.RefreshTokenEndDate)
                    
                    self.tokenRepository.saveTokenInfo(provider: tokenProvider, userName: "", password: "", userData: confirmationResponse.UserData)
                    
                    completion(confirmationResponse)
                    print("confirmationResponse: \(confirmationResponse)")
                }
                else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: confirmationResponse.Message)
                    
                    failure(errorDTO)
                }
            } error: { errorDTO in
                failure(errorDTO)
            }
        } failure: { errorDTO in
            failure(errorDTO)
        }
    }
    
    func logout() {
        tokenRepository.deleteToken()
    }
    
    func authenticateDevice() {
        let authDeviceRequestDTO: AuthenticateDeviceRequestDTO = AuthenticateDeviceRequestDTO(Username: ServiceConfiguration.AuthDeviceUsername,
                                                                                              Password: ServiceConfiguration.AuthDevicePassword,
                                                                                              Language: ServiceConfiguration.Language,
                                                                                              ProcessType: ServiceConfiguration.ProcessType)
        CipherHelper.encryption(requestDTO: authDeviceRequestDTO) { encryptedString in
            AccountService.authenticateDevice(request: encryptedString).request(responseDTO: AuthenticateDeviceResponseDTO.self) { authDeviceResponse in
                if let success = authDeviceResponse.Success, success {
                    if authDeviceResponse.Success! {
                        Constant.authDeviceToken = authDeviceResponse.MobileToken ?? ""
                    }
                } else {
                    var errorDTO: (APIErrorMessageProvider & Decodable)? = nil
                    errorDTO = APIErrorResponseDTO(Message: authDeviceResponse.Message)
                }
            } error: { errorDTO in
            }

        } failure: { errorDTO in
        }
    }
}

class MockAccountRepository: AccountRepository {
    var isUserLoggedIn: Bool = true
    
    var userId: String?
    
    func login(userName: String, password: String, completion: @escaping (LoginResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(LoginResponseDTO(
                UserName: "test@bilmsoft.com",
                Jwt: nil,
                ExpireDate: "0001-01-1T00:00:00",
                RefreshToken: nil,
                RefreshTokenEndDate: "0001-01-01T00:00:00",
                isConfirm: false,
                isConfirmCityDistrict: false,
                isOtp: false,
                UserData: nil,
                Success: false,
                Message: "api.account.login.ldapnotfinduser")
            )
        }
    }
    
    func otpCheck(userName: String, code: String, completion: @escaping (OTPCheckResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(OTPCheckResponseDTO(
                UserName: "bugrahan.sabuncu@bilmsoft.com",
                Jwt: "eyJhbGciOiJIUzI1NiIsInR",
                ExpireDate: "2022-07-9T11:13:29.9172463Z",
                RefreshToken: "VFPe7ceWrGT6fsa4CKHLE+",
                RefreshTokenEndDate: "2022-07-19",
                isConfirm: false,
                isConfirmCityDistrict: false,
                isOtp: false,
                UserData: UserData(
                    FirstName: "Buğrahan",
                    LastName: "Sabuncu",
                    CityId: 34,
                    DistrictId: 845,
                    CompanyId: 68,
                    StoreId: 1121,
                    EMailAdress: "bugrahan.sabuncu@bilmsoft.com",
                    PhoneNumber: "5334818843",
                    Permission: ["GeneralManagement","RegionalManagerEdit"]),
                Success: true,
                MenuList: [MenuList(Name: "")],
                Message: "api.account.otpcheck.loginsuccess")
            )
        }
    }
    
    func resendCode(userName: String, phoneNumber: String, completion: @escaping (ResendCodeResponseDTO) -> Void, failure: @escaping (APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(ResendCodeResponseDTO(
                CodeId: 0,
                Success: true,
                Message: "")
            )
        }
    }
    
    func confirmation(confirmationRequestDTO: ConfirmationRequestDTO, completion: @escaping (ConfirmationResponseDTO) -> Void, failure: @escaping(APIErrorMessageProvider?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let confirmationResponseDTO = ConfirmationResponseDTO(Success: true, Message: "", Jwt: "", ExpireDate: "", RefreshToken: "", RefreshTokenEndDate: "", UserName: "ozlem.jimenez@bilmsoft.site", UserData: nil, CodeId: 666666)
            completion(confirmationResponseDTO)
        }
    }
    
    func logout() {
        
    }
    
    func authenticateDevice() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Constant.authDeviceToken = ""
        }
    }
}
