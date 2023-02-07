//
//  PurchaseRequestDetailDto.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation


struct PurchaseRequestDetailDto: Codable {
    let RequestId: Int?
    let ProductId: Int?
    let ProductCode: String?
    let ProductName: String?
    let UnitPrice: Float?
    let Quantity: Int?
    let UserId: Int?
    let Id: Int?
    let InsertDate: String?
    var TotalPrice: Float? { return Float(Quantity ?? 0) * (UnitPrice ?? 0.0) }
}
