//
//  GetRegionalManagerRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 14.11.2022.
//

import Foundation

struct GetRegionalManagerRequestDTO: Codable, BaseRequest {
    let CurrentPage: Int
    let Language: String
    let ProcessType: Int
    let RecordSizeFromPage: Int
    let SortColumn: String
    let SortColumnAscDesc: String
    let Filter: RegionalManagerFilter
}
