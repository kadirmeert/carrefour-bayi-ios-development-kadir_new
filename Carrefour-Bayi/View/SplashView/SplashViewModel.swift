//
//  SplashViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation

protocol SplashViewModelDelegate: BaseViewModelDelegate {
    func navigateToHomePage()
    func navigateToLoginPage()
}

class SplashViewModel: BaseViewModel {
    weak var delegate: SplashViewModelDelegate?
    
    private let accountRepository: AccountRepository
    
    init(accountRepository: AccountRepository = RepositoryProvider.accountRepository) {
        self.accountRepository = accountRepository
    }
    
    func checkUserLoggedInAndNavigate() {
        accountRepository.authenticateDevice()

        if accountRepository.isUserLoggedIn {
            self.delegate?.navigateToHomePage()
        }
        else {
            self.delegate?.navigateToLoginPage()
        }
    }
}
