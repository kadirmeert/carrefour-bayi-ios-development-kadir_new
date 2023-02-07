//
//  GetOrderRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct GetOrderDetailRequestDTO: Codable, BaseRequest {
    let OrderId: Int
    let Language: String
    let ProcessType: Int
}
