//
//  GetAccountingReportResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import Foundation

struct GetAccountingReportResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let Records: [AccountingRecord]?
}


