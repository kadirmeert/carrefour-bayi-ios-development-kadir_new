//
//  SplashViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import UIKit

class SplashViewController: BaseViewController, SplashViewModelDelegate {
    // MARK: - Properties
    var viewModel: SplashViewModel!
    
    // MARK: - SplashViewModelDelegate Methods
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func contentDidLoad() {
        
    }
    
    override func contentWillLoad() {
        
    }
    
    override func readyForContent() {
        viewModel.checkUserLoggedInAndNavigate()
    }
    
    func navigateToHomePage() {
        let vc: MainViewController = MainViewController.create(companyAndStoreModel: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLoginPage() {
        let vc: LoginViewController = LoginViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Creator
extension SplashViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "SplashViewController"
        }
    }
    
    class func create() -> SplashViewController {
        let vc: SplashViewController = SplashViewController.instantiateFromNib()
        let viewModel: SplashViewModel = SplashViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
