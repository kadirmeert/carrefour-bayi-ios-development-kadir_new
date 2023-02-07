//
//  APIErrorResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

struct APIErrorResponseDTO: Codable, APIErrorMessageProvider {
    let Message: String?
    
    var messageText: String? {
        get {
            return Message
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case Message = "Message"
    }
}
