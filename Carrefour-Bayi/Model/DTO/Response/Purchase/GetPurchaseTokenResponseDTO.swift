//
//  GetPurchaseTokenResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 11.11.2022.
//

import Foundation

struct GetPurchaseTokenResponseDTO: Codable, BaseResponse {
    let Token: String?
    let Success: Bool?
    let Message: String?
}
