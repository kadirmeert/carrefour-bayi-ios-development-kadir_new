//
//  GetAllPurchaseResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetAllPurchaseResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let info: PurchaseRequestInfo?
    var Data: [PurchaseRequestData]?
}
