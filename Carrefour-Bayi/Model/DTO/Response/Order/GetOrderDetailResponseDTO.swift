//
//  GetOrderDetailResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.11.2022.
//

import Foundation

struct GetOrderDetailResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let OrderDetail: [OrderDetailData]?
}
