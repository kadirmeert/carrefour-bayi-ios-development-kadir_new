//
//  GetCompanyAndStoreListResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.09.2022.
//

import Foundation

struct GetCompanyAndStoreListResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let Items: [CompanyAndStore]?
}
