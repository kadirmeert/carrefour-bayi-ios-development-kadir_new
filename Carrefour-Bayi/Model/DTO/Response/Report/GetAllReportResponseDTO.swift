//
//  GetAllReportResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetAllReportsResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let Reports: [Report]?
}
