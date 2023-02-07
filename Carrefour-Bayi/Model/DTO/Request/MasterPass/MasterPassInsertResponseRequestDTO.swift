//
//  MasterPassInsertResponseRequestDTO.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.12.2022.
//

import Foundation


struct MasterPassInsertResponseRequestDTO: Codable, BaseRequest {
    var Language: String
    var ProcessType: Int
    var RequestName: String
    var reqRefNumber: String
    var responseCode: String
    var FullResponse: String
    var Token: String
    var url3D: String
}
