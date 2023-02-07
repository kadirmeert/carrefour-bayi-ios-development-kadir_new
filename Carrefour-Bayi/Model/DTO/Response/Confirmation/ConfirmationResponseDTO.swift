//
//  ConfirmationResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.08.2022.
//

import Foundation

struct ConfirmationResponseDTO: BaseResponse {
    var Success: Bool?
    var Message: String?
    var Jwt: String?
    var ExpireDate: String?
    var RefreshToken: String?
    var RefreshTokenEndDate: String?
    var UserName: String?
    var UserData: UserData?
    var CodeId: Int
}
