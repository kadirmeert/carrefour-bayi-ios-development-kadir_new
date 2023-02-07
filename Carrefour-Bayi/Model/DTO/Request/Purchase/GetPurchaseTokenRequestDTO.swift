//
//  GetPurchaseTokenRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 11.11.2022.
//

import Foundation

struct GetPurchaseTokenRequestDTO: Codable, BaseRequest {
    let Language: String
    let ProcessType: Int
}
