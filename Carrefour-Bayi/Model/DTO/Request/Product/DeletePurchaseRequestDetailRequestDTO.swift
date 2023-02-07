//
//  DeletePurchaseRequestDetailRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Mert on 18.01.2023.
//

import Foundation


struct DeletePurchaseRequestDetailRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var Id: Int

}
