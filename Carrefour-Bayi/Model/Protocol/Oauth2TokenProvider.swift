//
//  Oauth2TokenProvider.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation

protocol Oauth2TokenProvider {
    var Jwt: String? { get }
    var ExpireDate: String? { get }
    var RefreshToken: String? { get }
    var RefreshTokenEndDate: String? { get }
}
