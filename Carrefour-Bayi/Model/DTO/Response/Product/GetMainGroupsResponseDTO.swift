//
//  GetMainGroupsResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetMainGroupsResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let getAnaGruplarDtos: [AisleModel]?
}
