//
//  DeletePurchaseRequestDetailResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 19.01.2023.
//

import Foundation


struct DeletePurchaseRequestDetailResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
}
