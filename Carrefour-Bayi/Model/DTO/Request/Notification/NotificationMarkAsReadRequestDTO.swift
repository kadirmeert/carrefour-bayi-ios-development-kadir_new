//
//  NotificationMarkAsReadRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation

struct NotificationMarkAsReadRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    let NotificationId: Int
}
