//
//  GetPurchaseRequestDetailRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct GetPurchaseRequestDetailRequestDTO: Codable, BaseRequest {
    let CompanyId: Int
    let Language: String
    let ProcessType: Int
    let PurchaseId: Int
}
