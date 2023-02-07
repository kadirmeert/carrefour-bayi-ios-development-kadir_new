//
//  CompanyAndStore.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.09.2022.
//

import Foundation

struct CompanyAndStore: Codable {
//    let Company: CompanyItem?
    let CompanyId: Int?
    let CompanyCode: String?
    let CompanyName: String?
    var Stores: [StoreItem]?
}
