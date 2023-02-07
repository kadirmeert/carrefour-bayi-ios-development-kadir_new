//
//  GetProductByStockCodeRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductByStockCodeRequestDTO: Codable, BaseRequest {
    let StoreSAPCode: Int
    let StockCode: String
    let Language: String
    let ProcessType: Int

}
