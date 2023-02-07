//
//  GetMasterPassInfoRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


struct GetMasterPassInfoRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var Mode: String
    var CompanyCode: String
}
