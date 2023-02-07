//
//  AuthenticateDeviceResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 6.11.2022.
//

import Foundation


struct AuthenticateDeviceResponseDTO: Codable {
    let MobileToken: String?
    let ExpireDate: String?
    let Success: Bool?
    let Message: String?
}
