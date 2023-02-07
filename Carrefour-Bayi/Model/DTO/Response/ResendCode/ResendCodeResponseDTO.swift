//
//  ResendCodeResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import Foundation

struct ResendCodeResponseDTO: Codable {
    let CodeId: Int?
    let Success: Bool?
    let Message: String?
}
