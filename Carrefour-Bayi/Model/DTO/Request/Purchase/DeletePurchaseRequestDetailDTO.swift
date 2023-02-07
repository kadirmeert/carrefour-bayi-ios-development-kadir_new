//
//  DeletePurchaseRequestDetailDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct DeletePurchaseRequestDetailDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let PurchaseRequestDetailId: Int
}
