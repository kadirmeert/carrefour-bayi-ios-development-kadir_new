//
//  UpdatePurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct UpdatePurchaseRequestDetailDTO: Codable, BaseRequest {
    let Quantity: Int
    let PurchaseRequestDetailId: Int
    let StoreId: Int
    let ProductId: String
    let Language: String
    let ProcessType: Int
}
