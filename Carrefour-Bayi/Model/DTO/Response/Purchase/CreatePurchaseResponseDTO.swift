//
//  CreatePurchaseResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct CreatePurchaseResponseDTO: Codable, BaseResponse {
    let PurchaseRequestId: Int?
    let RequestNumber: String?
    let DateTime: String?
    let Success: Bool?
    let Message: String?
}
