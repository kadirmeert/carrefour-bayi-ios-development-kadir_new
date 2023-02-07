//
//  GetStoreResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import Foundation

struct GetStoreResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let StoreList: [Store]?
}
