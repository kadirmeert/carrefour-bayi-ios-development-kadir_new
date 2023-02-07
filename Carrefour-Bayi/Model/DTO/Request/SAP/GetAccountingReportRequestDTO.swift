//
//  GetAccountingReportRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import Foundation

struct GetAccountingReportRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let CompanyCode: String
    let StartDate: String
    let EndDate: String
    let Filter: AccountingFilter?
}
