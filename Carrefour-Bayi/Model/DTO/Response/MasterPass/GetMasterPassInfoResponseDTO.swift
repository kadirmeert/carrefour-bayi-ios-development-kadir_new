//
//  GetMasterPassInfoResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


struct GetMasterPassInfoResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    var clientId: String?
    var MacroMerchantId: String?
    var ClientSetAddress: String?
    var reqRefNumber: String?
    var sendSmsLanguage: String?
    var sendSms: String?
    var returnUrl: String?
}
