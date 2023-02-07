//
//  GetAllPurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct GetAllPurchaseRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let RecordSizeFromPage: Int
    var CurrentPage: Int
    let SortColumn: String
    let SortColumnAscDesc: String
    let CompanyId: Int
    let StoreId: Int
    let Filter: PurchaseRequestFilter
}
