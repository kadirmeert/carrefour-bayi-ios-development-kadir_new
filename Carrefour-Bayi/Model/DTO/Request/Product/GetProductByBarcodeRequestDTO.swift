//
//  GetProcudtByBarcodeRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct GetProductByBarcodeRequestDTO: Codable, BaseRequest {
    let storeSapCode: Int
    let Barcode: String
    let Language: String
    let ProcessType: Int
}


