//
//  CreatePurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct CreatePurchaseRequestDTO: Codable, BaseRequest {
    let CompanyId: Int
    let StoreId: Int
    let PurchaseRequestNo: String
    let PurchaseRequestDate: String
    let Language: String
    let ProcessType: Int
    
}
