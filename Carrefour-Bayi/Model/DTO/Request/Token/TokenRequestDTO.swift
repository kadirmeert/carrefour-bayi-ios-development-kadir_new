//
//  TokenRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 17.08.2022.
//

import Foundation

struct TokenRequestDTO: Codable {
    var Language: String = ServiceConfiguration.Language
    var ProcessType: Int = ServiceConfiguration.ProcessType
    let Username: String
    let Password: String
    
    static func createForUserToken(username: String, password: String) -> TokenRequestDTO {
        return TokenRequestDTO(Username: username, Password: password)
    }
}
