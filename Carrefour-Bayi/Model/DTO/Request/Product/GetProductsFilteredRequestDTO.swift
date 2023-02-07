//
//  GetProductsFilteredRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductsFilteredRequestDTO: Codable, BaseRequest {
    let StoreSAPCode: Int
    let ReyonKodu: Int
    let AnaGrupKodu: Int
    let AnaHamKodu: Int
    let MalGrupKodu: Int
    let Language: String
    let ProcessType: Int
}
