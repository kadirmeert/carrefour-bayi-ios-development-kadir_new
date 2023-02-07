//
//  GetMasterPassTokenRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation

struct GetMasterPassTokenRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var Mode: String
    var reqRefNumber: String
    var PhoneNumber: String
}
