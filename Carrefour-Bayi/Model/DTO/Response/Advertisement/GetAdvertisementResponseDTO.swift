//
//  GetAdvertisementResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.11.2022.
//

import Foundation

struct GetAdvertisementResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let Advertisements: [GetAdvertisementData]?
}
