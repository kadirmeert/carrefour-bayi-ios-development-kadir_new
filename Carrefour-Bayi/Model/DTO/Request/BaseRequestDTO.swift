//
//  BaseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

protocol BaseRequest: Codable {
    var Language: String { get }
    var ProcessType: Int { get }
}

struct BaseRequestDTO: BaseRequest {
    var Language: String
    var ProcessType: Int
}
