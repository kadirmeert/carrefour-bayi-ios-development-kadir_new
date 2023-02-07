//
//  CreatePurchaseRequestGetSerialNumberResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 23.12.2022.
//

import Foundation


struct CreatePurchaseRequestGetSerialNumberResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    var SerialNumber: String?
}
