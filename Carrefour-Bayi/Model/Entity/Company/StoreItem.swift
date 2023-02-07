//
//  StoreItem.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.09.2022.
//

import Foundation

struct StoreItem: Codable {
    let Id: Int?
    let CompanyId: Int?
    let Name: String?
    let Address: String?
    let CityId: Int?
    let DistrictId: Int?
    let StoreType: Int?
    let OpeningDate: String?
    let Contact: String?
    let Phone: String?
    let EmailAddress: String?
    let SAPCode: String?
}
