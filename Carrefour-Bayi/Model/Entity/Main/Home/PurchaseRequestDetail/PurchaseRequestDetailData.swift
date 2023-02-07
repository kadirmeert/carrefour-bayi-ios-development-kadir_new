//
//  PurchaseRequestDetailData.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct PurchaseRequestDetailData: Codable {
    let RequestId: Int?
    let ProductId: Int?
    let ProductCode: String?
    let ProductName: String?
    let KatSayi: Double?
    let UnitPrice: Double?
    let Quantity: Int?
    let UserId: Int?
    let TotalPrice: Double?
    let Success: Bool?
    let Message: String?
    let Id: Int?
    let InsertDate: String?
}
