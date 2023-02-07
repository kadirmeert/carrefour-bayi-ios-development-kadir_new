//
//  ConfirmationCreateModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.08.2022.
//

import Foundation

struct ConfirmationCreateModel: Codable {
    let isConfirmCityDistrict: Bool
    let UserName: String
    let CompanyId: Int
    let CityId: Int
    let DistrictId: Int
}
