//
//  Store.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import Foundation

struct Store: Codable {
    let Name: String
    let Address: String
    let IsActive: Bool
    let CityId: Int
    let DistrictId: Int
    let CompanyId: Int
    let StoreType: Int
    let OpeningDate: String
    let Contact: String
    let Phone: String
    let EmailAddress: String
    let SAPCode: String
    let CityName: String?
    let DistrictName: String?
    let UpdatedByUserId: Int
    let UpdatedDate: String
    let IsDeleted: Bool
    let Id: Int
    let InsertDate: String
    let TotalRowCount: Int
}
