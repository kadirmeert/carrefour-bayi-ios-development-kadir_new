//
//  GetCompanyAndStoreListRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.09.2022.
//

import Foundation

struct GetCompanyAndStoreListRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let CompanyId: Int
}
