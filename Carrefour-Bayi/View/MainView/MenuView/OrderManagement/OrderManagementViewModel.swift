//
//  OrderManagementViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.11.2022.
//

import Foundation

protocol OrderManagementViewModelDelegate: BaseViewModelDelegate {
    func navigateToOrderManagement()
    func navigateToRequestManagement()
}

class OrderManagementViewModel: BaseViewModel {
    weak var delegate: OrderManagementViewModelDelegate?
    
    var orderManagementItems: [OrderManagementItem]
    
    init(menuItems: [UserManagementItem] = []) {
        self.orderManagementItems = [
            OrderManagementItem(orderManagementItemTitle: "orderManagementItem".localized,
                                orderManagementItemIcon: "icon_right_arrow_shadow",
                                orderManagementItemCode: .orders, isVisible: true),
            OrderManagementItem(orderManagementItemTitle: "requestManagementItem".localized,
                                orderManagementItemIcon: "icon_right_arrow_shadow",
                                orderManagementItemCode: .requests, isVisible: true)
        ]
    }
    
    
    override func viewDidLoad() {
            fetchAndConfigureMenuItems()
    }
    
    
    func navigateToOrderManagementMenuItem(menuItemCode: OrderManagementAction) {
        switch menuItemCode {
            case .orders:
                delegate?.navigateToOrderManagement()
            case .requests:
                delegate?.navigateToRequestManagement()
        }
    }
}


//    MARK: - fetch menuList from DB -
extension OrderManagementViewModel {
    func fetchAndConfigureMenuItems() {
        let savedMenuList = UserDefaults.standard.string(forKey: "menuList")
//        let splitStringArray = savedMenuList?.components(separatedBy: ".")
        
        if !(savedMenuList?.contains(orderManagementItems[0].orderManagementItemCode.rawValue) ?? true) {
            self.orderManagementItems[0].isVisible = false
        }
        if !(savedMenuList?.contains(orderManagementItems[1].orderManagementItemCode.rawValue) ?? true) {
            self.orderManagementItems[1].isVisible = false
        }
        orderManagementItems.enumerated().forEach { (index, value) in
            if value.isVisible == false {
                orderManagementItems.remove(at: (index))
            }
        }
    }
}

