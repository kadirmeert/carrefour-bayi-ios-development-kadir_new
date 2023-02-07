//
//  OrderFilter.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation

struct OrderFilter: Codable {
    let OrderNumber: String?
    let FirstDate: String?
    let LastDate: String?
    let OrderState: Int?
    let MaxPrice: Double?
    let MinPrice: Double?
}
