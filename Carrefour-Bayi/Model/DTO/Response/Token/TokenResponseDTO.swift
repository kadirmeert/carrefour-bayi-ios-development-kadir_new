//
//  TokenResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation

struct TokenResponseDTO: Codable, Oauth2TokenProvider {
    var Jwt: String?
    var ExpireDate: String?
    var RefreshToken: String?
    var RefreshTokenEndDate: String?
    var Success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case Jwt = "Jwt"
        case ExpireDate = "ExpireDate"
        case RefreshToken = "RefreshToken"
        case RefreshTokenEndDate = "RefreshTokenEndDate"
        case Success = "Success"
    }
}
