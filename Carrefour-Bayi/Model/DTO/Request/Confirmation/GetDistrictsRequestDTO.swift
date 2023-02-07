//
//  GetDistrictsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.08.2022.
//

import Foundation

struct GetDistrictsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let CityId: Int
}
