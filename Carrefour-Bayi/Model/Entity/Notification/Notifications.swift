//
//  Notifications.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.11.2022.
//

import Foundation

struct Notifications: Codable {
    let Id: Int?
    let Title: String?
    let Body: String?
    var IsRead: Bool?
    let InsertDate: String?
}
