//
//  BaseViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation
import UIKit
import JGProgressHUD

class BaseViewController: UIViewController, BaseViewModelDelegate {
    // MARK:- Properties
    private var viewModel: BaseViewModel!
    private var progressViewCount: Int = 0
    
    // MARK:- Views
    private let progressHUD = JGProgressHUD(style: .light)
    let backView: UIView = {
       let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let baseVM = provideViewModel() else {
            fatalError("A view model must be provided")
        }
        
        viewModel = baseVM
        viewModel.baseVMDelegate = self
        
        viewModel.viewDidLoad()
        backView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        backView.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
    
    // MARK:- BaseViewModel Provider
    func provideViewModel() -> BaseViewModel? {
        return nil
    }
    
    // MARK:- BaseViewModelDelegate
    func readyForContent() {
        
    }
    
    func contentDidLoad() {
        progressViewCount -= 1

        guard progressViewCount == 0 else {
            return
        }


        UIView.transition(with: backView, duration: 0.3, options: .transitionCrossDissolve) {
            self.backView.alpha = 0
        } completion: { _ in
            self.backView.removeFromSuperview()
        }
        progressHUD.dismiss()
    }
    
    func contentWillLoad() {
        progressViewCount += 1

        guard progressViewCount == 1 else {
            return
        }
        
        view.addSubview(backView)
        progressHUD.show(in: self.view)
    }
    
    func userMustReLogin() {
        let action = UIAlertAction(title: "done".localized, style: .default) { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                SceneDelegate.shared.rootNavController?.popToRootViewController(animated: true)
            }
        }
        self.showErrorAlert(message: "userReLoginMessage".localized, customAction: action)
    }
}

