//
//  InsertDirectPurchaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.01.2023.
//

import Foundation


struct InsertDirectPurchaseRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var UserId: Int
    var msisdn: String
    var CardNumberMasked: String
    var ExpirationDate: String
    var CardHolderName: String
    var Amount: String
    var reqRefNumber: String
    var Token: String
    var sendSmsLanguage: String
    var macroMerchantId: String
    var sendSms: String
    var FullResponse: String
}
