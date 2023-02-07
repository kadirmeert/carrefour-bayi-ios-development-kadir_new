//
//  ImportPurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct ImportPurchaseRequestDTO: Codable, BaseRequest {
    let CompanyId: Int
    let StoreId: Int
    let Language: String
    let ProcessType: Int
}
