//
//  CreatePurchaseRequestDetailDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct CreatePurchaseRequestDetailDTO: Codable, BaseRequest {
    let StoreId: Int
    let PurchaseRequestId: Int
    let ProductId: String
    let Quantity: Int
    let Language: String
    let ProcessType: Int
}
