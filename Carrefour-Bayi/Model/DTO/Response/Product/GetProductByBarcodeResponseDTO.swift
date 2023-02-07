//
//  GetProductByBarcodeResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductByBarcodeResponseDTO: Codable, BaseResponse {
    let Barkod: String?
    let ProductId: Int?
    let ProductCode: Int?
    let ProductName: String?
    let Birimi: String?
    let ReyonKodu: Int?
    let AnaGrupKodu: Int?
    let AnaHamKodu: Int?
    let MalGrubuKodu: Int?
    let Success: Bool?
    let Message: String?
}
