//
//  BaseViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation

protocol BaseViewModelDelegate: AnyObject {
    func contentWillLoad()
    func contentDidLoad()
    func readyForContent()
    func userMustReLogin()
}

class BaseViewModel: NSObject {
    // MARK:- Properties
    weak var baseVMDelegate: BaseViewModelDelegate?
    func viewDidLoad(){}
    
    func viewWillAppear(){
        NotificationCenter.default.addObserver(self, selector: #selector(userMustReLogin(_:)), name: .userMustReLogin, object: nil)
    }
    
    func viewDidAppear() {
        baseVMDelegate?.readyForContent()
    }
    
    func viewWillDisappear(){
    }
    
    func viewDidDisappear(){}
    
    @objc func userMustReLogin(_ sender: Any?) {
        self.baseVMDelegate?.userMustReLogin()
    }
}
