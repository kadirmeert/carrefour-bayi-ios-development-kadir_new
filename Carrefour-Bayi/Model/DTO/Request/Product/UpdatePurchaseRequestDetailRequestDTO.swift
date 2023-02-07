//
//  UpdatePurchaseRequestDetailRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation

struct UpdatePurchaseRequestDetailRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var Quantity: Int
    var PurchaseRequestId: Int
    var ProductId: String
}
