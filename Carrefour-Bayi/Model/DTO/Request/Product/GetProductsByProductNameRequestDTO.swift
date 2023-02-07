//
//  GetProductsByProductNameRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation


struct GetProductsByProductNameRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let storeSapCode: Int
    let text: String
    let RequestDate: String
}
