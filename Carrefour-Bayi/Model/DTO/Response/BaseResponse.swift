//
//  BaseResponse.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 12.08.2022.
//

import Foundation

protocol BaseResponse: Codable {
    var Success: Bool? { get }
    var Message: String? { get }
}

struct BaseResponseDTO: BaseResponse {
    var Success: Bool?
    var Message: String?
}
