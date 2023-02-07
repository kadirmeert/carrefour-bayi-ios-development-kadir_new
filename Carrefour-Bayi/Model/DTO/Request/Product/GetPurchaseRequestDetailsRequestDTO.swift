//
//  GetPurchaseRequestDetailsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation


struct GetPurchaseRequestDetailsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var CompanyId: Int
    var PurchaseId: Int
}
