//
//  GetAislesRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 24.12.2022.
//

import Foundation


struct GetAislesRequestDTO: Codable, BaseRequest {
    var ProcessType: Int
    var Language: String
    var StoreSapCode: Int
    var Text: String
}
