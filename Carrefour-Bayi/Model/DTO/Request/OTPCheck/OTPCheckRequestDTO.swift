//
//  OTPCheckRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import Foundation

struct OTPCheckRequestDTO: Codable {
    let Language: String
    let ProcessType: Int
    let Username: String
    let Code: String
}
