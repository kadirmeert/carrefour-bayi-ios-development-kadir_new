//
//  CreatePurchaseRequestGetSerialNumberRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 23.12.2022.
//

import Foundation


struct CreatePurchaseRequestGetSerialNumberRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var StoreId: Int
}
