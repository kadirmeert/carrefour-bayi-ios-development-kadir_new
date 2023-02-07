//
//  OrderData.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.09.2022.
//

import Foundation

struct OrderData: Codable {
    let Id: Int
    let InsertDate: String
    let Name: String
    let CompanyId: Int
    let StoreId: Int
    let OrderDate: String
    let StateCode: Int
    let TotalPrice: Double
    let UpdatedByUserId: Int
    let UpdatedDate: String
    let IsDeleted: Bool
    let StateCodeValue: String
    let TotalRowCount: Int
}
