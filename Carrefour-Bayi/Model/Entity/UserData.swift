//
//  UserData.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import Foundation

struct UserData: Codable {
    let FirstName: String?
    let LastName: String?
    let CityId: Int?
    let DistrictId: Int?
    let CompanyId: Int?
    let StoreId: Int?
    let EMailAdress: String?
    let PhoneNumber: String?
    let Permission: [String?]?
}
