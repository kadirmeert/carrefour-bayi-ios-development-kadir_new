//
//  GetStoreRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import Foundation

struct GetStoreRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let CompanyId: Int
}
