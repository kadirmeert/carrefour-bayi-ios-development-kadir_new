//
//  GetCitiesResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

struct GetCitiesResponseDTO: Codable {
    let Cities: [City]?
    let Success: Bool?
    let Message: String?
}
