//
//  GetPurchaseRequestDetailsResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation


struct GetPurchaseRequestDetailsResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let Data: [PurchaseRequestDetailDto]?
}
