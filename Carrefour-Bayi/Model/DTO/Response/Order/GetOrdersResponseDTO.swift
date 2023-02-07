//
//  GetOrdersResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation

struct GetOrdersResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let info: OrderInfo?
    var Data: [OrderData]?
}
