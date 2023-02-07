//
//  MenuViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 22.08.2022.
//

import Foundation
import UIKit

protocol MenuViewModelDelegate: BaseViewModelDelegate {
    func logoutCompleted()
    func navigateToAccountingPage()
    func navigateToReportsPage()
    func navigateToUserManagement()
    func navigateToOrderManagement()
}

class MenuViewModel: BaseViewModel {
    weak var delegate: MenuViewModelDelegate?
    private var accountRepository: AccountRepository
    
    var menuItems: [MenuItem]
    var isReportMenuUp: Bool = false
    var isUserManagementMenuUp: Bool = false
    var isOrderManagementMenuUp: Bool = false
    
    init(menuItems: [MenuItem] = [], accountRepository: AccountRepository = RepositoryProvider.accountRepository) {
        self.menuItems = [
                          MenuItem(menuTitle: "orders".localized, menuIcon: "icon_tab_order", menuItemCode: .orders, hasDetail: true, isVisible: true),
                          MenuItem(menuTitle: "reportsAndStock".localized, menuIcon: "icon_reports", menuItemCode: .reportsAndStock, hasDetail: true, isVisible: false),
                          MenuItem(menuTitle: "userManagement".localized, menuIcon: "icon_user_blue", menuItemCode: .userManagement, hasDetail: true, isVisible: true),
                          MenuItem(menuTitle: "memberBusinesses".localized, menuIcon: "icon_store_blue", menuItemCode: .memberBusinesses, hasDetail: false, isVisible: false),
                          MenuItem(menuTitle: "consensusAndAccounting".localized, menuIcon: "icon_tab_accounting", menuItemCode: .consensusAndAccounting, hasDetail: false, isVisible: true)
                         ]
        
        self.accountRepository = accountRepository
        super.init()
    }
    
    override func viewDidLoad() {
        self.fetchAndCreateNewItems()
    }
    
    func navigateToMenuItem(menuItemCode: MenuAction) {
        switch menuItemCode {
        case .orders:
            delegate?.navigateToOrderManagement()
        case .reportsAndStock:
            delegate?.navigateToReportsPage()
        case .userManagement:
            delegate?.navigateToUserManagement()
        case .memberBusinesses:
            print("member businesses")
        case .consensusAndAccounting:
            delegate?.navigateToAccountingPage()
//        case .debts:
//            print("depts")
//        case .announcements:
//            print("announcements")
        }
    }
    
    func logout() {
        accountRepository.logout()
        delegate?.logoutCompleted()
    }
}


//    MARK: - fetch menuList from DB -
extension MenuViewModel {
    func fetchAndCreateNewItems() {
        let savedMenuList = UserDefaults.standard.string(forKey: "menuList")
//        let splitStringArray = savedMenuList?.components(separatedBy: ".")
        
        if !(savedMenuList?.contains(menuItems[0].menuItemCode.rawValue) ?? true) || !(savedMenuList?.contains("purchaseRequests") ?? true) {
            self.menuItems[0].isVisible = false
        }
        if !(savedMenuList?.contains(menuItems[2].menuItemCode.rawValue) ?? true) {
            self.menuItems[2].isVisible = false
        }
        if !(savedMenuList?.contains(menuItems[4].menuItemCode.rawValue) ?? true) {
            self.menuItems[4].isVisible = false
        }
        
        var deletedItemCount: Int = 0
        menuItems.enumerated().forEach { (index, value) in
            if value.isVisible == false {
                menuItems.remove(at: (index - deletedItemCount))
                deletedItemCount += 1
            }
        }
    }
}
