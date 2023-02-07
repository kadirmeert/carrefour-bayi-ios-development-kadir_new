//
//  PurchaseRequestFilter.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct PurchaseRequestFilter: Codable {
    let Name: String?
    let FirstDate: String?
    let LastDate: String?
    let MaxPrice: Double?
    let MinPrice: Double?
    let StateCodeValue: Int?
}
