//
//  GetAllReportsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetAllReportsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let SAPCode: Int
}
