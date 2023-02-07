//
//  LoginViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

protocol LoginViewModelDelegate: BaseViewModelDelegate {
    func navigateToOTPPage(userName: String)
    func navigateToHomePage()
    func navigateToConfirmationPage(confirmationModel: ConfirmationCreateModel)
    func loginFailed(errorMessage: String)
}

class LoginViewModel: BaseViewModel {
    private let accountRepository: AccountRepository
    weak var delegate: LoginViewModelDelegate?
    
    init(accountRepository: AccountRepository = RepositoryProvider.accountRepository) {
        self.accountRepository = accountRepository
    }
    
    func performLogin(userName: String, password: String) {
        baseVMDelegate?.contentWillLoad()
        UserDefaults.standard.set(0, forKey: "LastOTPCounterValue")
        accountRepository.login(userName: userName, password: password) {[weak self] loginResponse in
#if DEBUG
            print("VEYSEL <<<< login response is here -> ", loginResponse)
#endif
            self?.baseVMDelegate?.contentDidLoad()
            if let isConfirm = loginResponse.isConfirm, isConfirm {
                let confirmationModel: ConfirmationCreateModel = ConfirmationCreateModel(isConfirmCityDistrict: loginResponse.isConfirmCityDistrict ?? false, UserName: loginResponse.UserName ?? "", CompanyId: loginResponse.UserData?.CompanyId ?? 0, CityId: loginResponse.UserData?.CityId ?? 0, DistrictId: loginResponse.UserData?.DistrictId ?? 0)
                
                self?.delegate?.navigateToConfirmationPage(confirmationModel: confirmationModel)
            }
            else if let isOTP = loginResponse.isOtp, isOTP {
                self?.delegate?.navigateToOTPPage(userName: userName)
            }
            else {
                self?.delegate?.navigateToHomePage()
            }
            
        } failure: {[weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.loginFailed(errorMessage: errorDTO?.messageText ?? "")
        }
    }
}
