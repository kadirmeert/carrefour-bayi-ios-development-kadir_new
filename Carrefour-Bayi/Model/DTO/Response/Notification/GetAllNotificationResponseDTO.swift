//
//  GetAllNotificationResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation

struct GetAllNotificationResponseDTO: Codable, BaseResponse {
    var Notifications: [Notifications]?
    var Success: Bool?
    var Message: String?
}
