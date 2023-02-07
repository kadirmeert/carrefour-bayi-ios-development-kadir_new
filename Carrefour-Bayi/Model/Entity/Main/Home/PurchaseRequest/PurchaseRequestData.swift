//
//  PurchaseRequestData.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

struct PurchaseRequestData: Codable {
    let Id: Int?
    let InsertDate: String?
    let Name: String?
    let CompanyId: Int?
    let StoreId: Int?
    let RequestDate: String?
    let StateCode: Int?
    let SubProductCount: Int?
    let UpdatedByUserId: Int?
    let UpdatedDate: String?
    let IsDeleted: Bool?
    let TotalPrice: Double?
    let StateCodeValue: String?
    let TotalRowCount: Int?
}
