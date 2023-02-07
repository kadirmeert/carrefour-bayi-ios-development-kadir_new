//
//  CreatePurchaseRequestDetailRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation


struct CreatePurchaseRequestDetailRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var StoreId: Int
    var PurchaseRequestId: Int
    var ProductId: Int
    var Quantity: Int
    

}
