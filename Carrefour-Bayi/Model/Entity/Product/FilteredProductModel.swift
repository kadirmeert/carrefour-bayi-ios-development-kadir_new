//
//  FilteredProductModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct FilteredProductModel: Codable {
    let Id: Int?
    let Name: String?
    let Code: String?
    let IsActive: Bool?
    let ProductCategoryName: String?
    let ProductCategoryId: Int?
    let Price: Double?
    let ReyonKodu: Int?
    let AnaGrupKodu: Int?
    let AnaHamKodu: Int?
    let MalGrubuKodu: Int?
    let Categories: [String]?
}
