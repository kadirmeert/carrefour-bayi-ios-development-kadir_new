//
//  GetCreditLimitResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import Foundation

struct GetCreditLimitResponseDTO: Codable, BaseResponse {
    let TotalLimit: Double?
    let RemainingLimit: Double?
    let UsedLimit: Double?
    var Success: Bool?
    var Message: String?
}
