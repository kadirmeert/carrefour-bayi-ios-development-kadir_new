//
//  GetMainProductsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 24.12.2022.
//

import Foundation


struct GetMainProductsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var StoreSAPCode: Int
    var reyonkodu: Int
    var Text: String
}
