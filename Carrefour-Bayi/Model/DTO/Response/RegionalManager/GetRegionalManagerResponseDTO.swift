//
//  GetRegionalManagerResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

struct GetRegionalManagerResponseDTO: Codable, BaseResponse {
    let Info: RegionalManagerInfo?
    let RegionalManagers: [RegionalManagerData]?
    let Success: Bool?
    let Message: String?

}
