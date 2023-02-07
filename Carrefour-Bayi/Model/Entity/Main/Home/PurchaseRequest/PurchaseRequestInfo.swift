//
//  PurchaseRequestInfo.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct PurchaseRequestInfo: Codable {
    let Count: Int?
    let Pages: Int?
    let Next: String?
    let Prev: String?
}
