//
//  GetProductGroupsRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 24.12.2022.
//

import Foundation


struct GetProductGroupsRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var StoreSAPCode: Int
    var AnaGrupKodu: Int
    var Text: String
}
