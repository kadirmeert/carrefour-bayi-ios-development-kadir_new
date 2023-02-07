//
//  GetAccountingReportExcelRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 16.11.2022.
//

import Foundation

struct GetAccountingReportExcelRequestDTO: Codable, BaseRequest {
    let CompanyCode: String
    let EndDate: String
    let StartDate: String
    var Language: String
    var ProcessType: Int
}
