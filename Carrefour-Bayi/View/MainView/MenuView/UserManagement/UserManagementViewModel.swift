//
//  UserManagementViewModel.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 13.11.2022.
//

import Foundation

protocol UserManagementViewModelDelegate: BaseViewModelDelegate {
    func navigateToRegionalManagers()
}

class UserManagementViewModel: BaseViewModel {
    weak var delegate: UserManagementViewModelDelegate?
    
    var userManagementItems: [UserManagementItem]
    
    init(menuItems: [UserManagementItem] = []) {
        self.userManagementItems = [UserManagementItem(userManagementItemTitle: "regionalManagers".localized, userManagementItemIcon: "icon_right_arrow_shadow", userManagementItemCode: .regionalManagers)]
    }
    
    func navigateToUserManagementMenuItem(menuItemCode: UserManagementAction) {
        switch menuItemCode {
        case .regionalManagers:
            delegate?.navigateToRegionalManagers()
        }
    }
}
