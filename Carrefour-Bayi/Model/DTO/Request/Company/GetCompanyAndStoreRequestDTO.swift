//
//  GetCompanyAndStoreRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetCompanyAndStoreRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let CompanyId: Int
    let StoreId: Int
}
