//
//  MasterPassCommitPurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


struct MasterPassCommitPurchaseRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var Mode: String
    var reqRefNumber: String
    var token: String
}
