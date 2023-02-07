//
//  AuthenticateDeviceRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 6.11.2022.
//

import Foundation


struct AuthenticateDeviceRequestDTO: Codable {
    let Username: String
    let Password: String
    let Language: String
    let ProcessType: Int
}
