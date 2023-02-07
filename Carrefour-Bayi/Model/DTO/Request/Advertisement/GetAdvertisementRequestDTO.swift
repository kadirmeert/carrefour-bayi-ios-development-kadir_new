//
//  GetAdvertisementRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.11.2022.
//

import Foundation

struct GetAdvertisementRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
}
