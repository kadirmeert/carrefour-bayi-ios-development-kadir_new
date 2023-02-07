//
//  GetMainProductsResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetMainProductsResponseDTO: Codable, BaseResponse {
    let getAnaHamlarDtos: [AisleModel]?
    var Success: Bool?
    var Message: String?
}
