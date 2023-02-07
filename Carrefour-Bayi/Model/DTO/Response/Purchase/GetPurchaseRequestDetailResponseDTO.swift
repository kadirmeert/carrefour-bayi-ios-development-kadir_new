//
//  GetPurchaseRequestDetailResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct GetPurchaseRequestDetailResponseDTO: Codable, BaseResponse {
    let Data: [PurchaseRequestDetailData]?
    let Success: Bool?
    let Message: String?
}
