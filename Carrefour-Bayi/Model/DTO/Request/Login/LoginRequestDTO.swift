//
//  LoginRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

struct LoginRequestDTO: Codable {
    let Language: String
    let ProcessType: Int
    let Username: String
    let Password: String
}
