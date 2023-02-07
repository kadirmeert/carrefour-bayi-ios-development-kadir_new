//
//  OTPCheckViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import Foundation

protocol OTPCheckViewModelDelegate: BaseViewModelDelegate {
    func otpCheckFailed(error: String)
    func resendCodeSuccess()
    func contentFailed(error: String)
    func otpCodeCheckSuccess()
}

class OTPCheckViewModel: BaseViewModel {
    weak var delegate: OTPCheckViewModelDelegate?
    private var accountRepository: AccountRepository
    private var tokenRepository: TokenRepository
    
    var userName: String
    var phoneNumber: String
    var codeId: Int
    
    var confirmationRequest: ConfirmationRequestDTO?
    
    init(accountRepository: AccountRepository = RepositoryProvider.accountRepository,
         tokenRepository: TokenRepository = RepositoryProvider.tokenRepository,
         userName: String, phoneNumber: String = "", codeId: Int = 0, confirmationRequest: ConfirmationRequestDTO? = nil) {
        self.accountRepository = accountRepository
        self.tokenRepository = tokenRepository
        self.userName = userName
        self.phoneNumber = phoneNumber
        self.codeId = codeId
        self.confirmationRequest = confirmationRequest
    }
    
    func performConfirmOrOTPCheck(code: String) {
        if let confirmationRequest = confirmationRequest {
            var confirmationRequest: ConfirmationRequestDTO = confirmationRequest
            confirmationRequest.SmsCode = code
            
            self.performConfirmation(confirmationRequest: confirmationRequest)
        }
        else {
            self.performOTPCheck(code: code)
        }
    }
    
    private func performOTPCheck(code: String) {
        baseVMDelegate?.contentWillLoad()
        
        accountRepository.otpCheck(userName: userName, code: code) {[weak self] otpCheckResponse in
            self?.baseVMDelegate?.contentDidLoad()
            if let phoneNumber = otpCheckResponse.UserData?.PhoneNumber {
                UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
                self?.tokenRepository.saveUserPhoneNumber(phoneNumber: phoneNumber)
            }
            
            if let menuList = otpCheckResponse.MenuList {
                self?.saveMenuListToDB(menuList: menuList)
            }
            self?.delegate?.otpCodeCheckSuccess()
        } failure: {[weak self] errorDTO in
            if let message = errorDTO?.messageText, message == "api.account.resendcode.otpcheckinvalid" {
                self?.delegate?.otpCheckFailed(error: errorDTO?.messageText ?? "generalErrorMessage34234".localized)
            }
            else {
                self?.delegate?.contentFailed(error: errorDTO?.messageText ?? "generalErrorMessage12".localized)
            }
            
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    private func performConfirmation(confirmationRequest: ConfirmationRequestDTO) {
        baseVMDelegate?.contentWillLoad()
        
        accountRepository.confirmation(confirmationRequestDTO: confirmationRequest) {[weak self] confirmationResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.otpCodeCheckSuccess()
        } failure: {[weak self] errorDTO in
            if let message = errorDTO?.messageText, message == "api.account.resendcode.otpcheckinvalid" {
                self?.delegate?.otpCheckFailed(error: errorDTO?.messageText ?? "generalErrorMessage111".localized)
            }
            else {
                self?.delegate?.contentFailed(error: errorDTO?.messageText ?? "generalErrorMessage121312".localized)
            }
            
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func performResendCode() {
        baseVMDelegate?.contentWillLoad()
        accountRepository.resendCode(userName: userName, phoneNumber: phoneNumber) {[weak self] resendCodeResponse in
            print(resendCodeResponse)
            
            if let codeId = resendCodeResponse.CodeId {
                self?.codeId = codeId
                
                if self?.confirmationRequest != nil {
                    self?.confirmationRequest?.CodeId = codeId
                }
                
                self?.delegate?.resendCodeSuccess()
            }
            
            self?.baseVMDelegate?.contentDidLoad()
        } failure: {[weak self] errorDTO in
            self?.delegate?.contentFailed(error: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
}


//          Carrefour.MenuList(Name: "menu.dashboard")
//          Carrefour.MenuList(Name: "menu.name.orders")
//          Carrefour.MenuList(Name: "menu.name.purchaseRequests")
//          Carrefour.MenuList(Name: "menu.name.ordersuggestion")
//          Carrefour.MenuList(Name: "menu.name.accounting")
//          Carrefour.MenuList(Name: "menu.name.regionalmanagers")


//    MARK: - save MenuList to DB -
extension OTPCheckViewModel {
    func saveMenuListToDB(menuList: [MenuList]) {
        var menuListString: String = ""
            menuList.forEach { menuItem in
                if let name = menuItem.Name {
                    let splitString = (name.components(separatedBy: ".")).last
                    menuListString.append(splitString! + ".")
                }
            }
            menuListString.removeLast()
        UserDefaults.standard.set(menuListString, forKey: "menuList")
        #if DEBUG
        print("VEYSEL <<<< menuListString -> ", menuListString)
        #endif
    }
}
