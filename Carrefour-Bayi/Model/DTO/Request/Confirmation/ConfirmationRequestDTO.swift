//
//  ConfirmationRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.08.2022.
//

import Foundation

struct ConfirmationRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let UserName: String
    let CompanyId: Int
    let CityId: Int
    let DistrictId: Int
    let phoneNumber: String
    var SmsCode: String
    var CodeId: Int
}
