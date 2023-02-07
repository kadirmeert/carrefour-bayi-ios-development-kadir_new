//
//  OrderInfo.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation

struct OrderInfo: Codable {
    let Count: Int?
    let Pages: Int?
    let Next: String?
    let Prev: String?
}
