//
//  UpdatePurchaseResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct UpdatePurchaseResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    var Data: [PurchaseRequestDetailData]?
}
