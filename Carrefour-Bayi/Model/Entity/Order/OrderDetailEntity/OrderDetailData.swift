//
//  OrderDetailData.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct OrderDetailData: Codable {
    let Id: Int?
    let OrderId: Int?
    let ProductId: String?
    let ProductName: String?
    let UnitPrice: Double?
    let Quantity: Int?
    let TotalPrice: Double?
}
