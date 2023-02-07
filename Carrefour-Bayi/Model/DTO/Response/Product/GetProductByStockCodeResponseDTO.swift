//
//  GetProductByStockCodeResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductByStockCodeResponseDTO: Codable, BaseResponse {
    let Id: Int?
    let Name: String?
    let Code: String?
    let IsActive: Bool?
    let ProductCategoryName: String?
    let ProductCategoryId: Int?
    let Price: Float?
    let ReyonKodu: Int?
    let AnaGrupKodu: Int?
    let AnaHamKodu: Int?
    let MalGrubuKodu: Int?
    let Categories: [ProductCategoryModel]?
    let Success: Bool?
    let Message: String?
}
