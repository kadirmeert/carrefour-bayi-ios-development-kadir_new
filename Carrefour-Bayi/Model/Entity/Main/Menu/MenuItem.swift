//
//  MenuItem.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 22.08.2022.
//

import Foundation

struct MenuItem {
    let menuTitle: String
    let menuIcon: String
    let menuItemCode: MenuAction
    let hasDetail: Bool
    var isVisible: Bool
}


struct MenuList: Codable {
    let Name: String?
}
