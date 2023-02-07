//
//  GetStoreDashboardDetailRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import Foundation

struct GetStoreDashboardDetailRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let SAPCode: String
}
