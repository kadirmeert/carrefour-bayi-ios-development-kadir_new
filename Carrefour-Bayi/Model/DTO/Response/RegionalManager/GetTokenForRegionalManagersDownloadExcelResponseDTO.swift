//
//  GetTokenForRegionalManagersDownloadExcelResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

struct GetTokenForRegionalManagersDownloadExcelResponseDTO: Codable, BaseResponse {
    let Token: String?
    var Message: String?
    var Success: Bool?
}
