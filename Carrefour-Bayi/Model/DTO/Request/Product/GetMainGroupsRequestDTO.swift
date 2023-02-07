//
//  GetMainGroupsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 24.12.2022.
//

import Foundation


struct GetMainGroupsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var StoreSAPCode: Int
    var AnaHamKodu: Int
    var Text: String
}
