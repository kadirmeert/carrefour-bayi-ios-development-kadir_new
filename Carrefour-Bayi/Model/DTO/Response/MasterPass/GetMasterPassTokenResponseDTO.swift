//
//  GetMasterPassTokenResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


struct GetMasterPassTokenResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    var tokenWithoutMSISDN: String?
    var token: String?
}
