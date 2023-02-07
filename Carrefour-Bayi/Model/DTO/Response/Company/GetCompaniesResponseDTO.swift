//
//  GetCompaniesResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import Foundation

struct GetCompaniesResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let companies: [Company]?
}
