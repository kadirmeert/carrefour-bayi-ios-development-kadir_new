//
//  CompanyItem.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.09.2022.
//

import Foundation

struct CompanyItem: Codable {
    let Id: Int?
    let CityId: Int?
    let DistrictId: Int?
    let CompanyCode: String?
    let CompanyName: String?
    let TaxOffice: String?
    let TaxNumber: String?
    let Address: String?
    let CompanyType: Int?
    let Phone: String?
    let EmailAddress: String?
}
