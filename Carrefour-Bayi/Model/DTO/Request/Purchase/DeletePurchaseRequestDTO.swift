//
//  DeletePurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.12.2022.
//

import Foundation

struct DeletePurchaseRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let Id: Int
}
