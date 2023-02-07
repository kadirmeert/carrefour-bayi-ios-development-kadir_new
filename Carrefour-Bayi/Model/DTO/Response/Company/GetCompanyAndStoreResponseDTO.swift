//
//  GetCompanyAndStoreResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetCompanyAndStoreResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let CompanyId: Int?
    let CompanyName: String?
    let StoreId: Int?
    let StoreName: String?
    let SAPCode: String?
    let CompanyCode: String?
}


struct CurrentCompanyAndStore {
    var companyID: Int
    var storeID: Int
    var sapCode: Int
    var companyCode: String
}
