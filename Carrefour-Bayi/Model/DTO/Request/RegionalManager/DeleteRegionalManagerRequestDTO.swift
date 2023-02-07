//
//  DeleteRegionalManagerRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

struct DeleteRegionalManagerRequestDTO: Codable, BaseRequest {
    let RegionalManagerId: Int
    var ProcessType: Int
    var Language: String
}
