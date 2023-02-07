//
//  GetDistrictsResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

struct GetDistrictsResponseDTO: Codable {
    let Districts: [District]?
    let Success: Bool?
    let Message: String?
}
