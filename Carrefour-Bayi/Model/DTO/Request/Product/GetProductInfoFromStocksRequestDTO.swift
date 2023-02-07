//
//  GetProductInfoFromStocksRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductInfoFromStocksRequestDTO: Codable, BaseRequest {
    let ProductId: Int
    let SAPCode: Int
    let Language: String
    let ProcessType: Int
}
