//
//  GetCreditLimitRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import Foundation

struct GetCreditLimitRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let SAPCode: Int
}
