//
//  GetProductsByProductNameResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductsByProductNameResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    var getProductsByTextinNameDtos: [ProductModel]?
}
