//
//  GetAccountingReportExcelResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 16.11.2022.
//

import Foundation

struct GetAccountingReportExcelResponseDTO: Codable, BaseResponse {
    var Message: String?
    var Success: Bool?
    let Token: String?
}
