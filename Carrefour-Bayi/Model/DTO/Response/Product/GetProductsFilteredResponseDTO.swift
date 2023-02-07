//
//  GetProductsFilteredResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductsFilteredResponseDTO: Codable {
    var Success: Bool?
    var Message: String?
    let getProductsFilteredDtos: [FilteredProductModel]?
}
