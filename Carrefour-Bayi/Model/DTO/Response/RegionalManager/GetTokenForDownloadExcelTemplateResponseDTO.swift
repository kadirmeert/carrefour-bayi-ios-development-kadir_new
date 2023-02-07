//
//  DeleteRegionalManagerResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

struct GetTokenForDownloadExcelTemplateResponseDTO: Codable, BaseResponse {
    let Token: String?
    var Message: String?
    var Success: Bool?
}
