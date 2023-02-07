//
//  LoginResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

struct LoginResponseDTO: Codable {
    let UserName: String?
    let Jwt: String?
    let ExpireDate: String?
    let RefreshToken: String?
    let RefreshTokenEndDate: String?
    let isConfirm: Bool?
    let isConfirmCityDistrict: Bool?
    let isOtp: Bool?
    let UserData: UserData?
    let Success: Bool?
    let Message: String?
}
