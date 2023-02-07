//
//  SendPurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct SendPurchaseRequestDTO: Codable, BaseRequest {
    let PurchaseRequestId: Int
    let Language: String
    let ProcessType: Int
}
