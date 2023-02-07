//
//  SetFCMTokenRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation

struct SetFCMTokenRequestDTO: Codable, BaseRequest {
    let FCMToken: String
    var Language: String
    var ProcessType: Int
}
