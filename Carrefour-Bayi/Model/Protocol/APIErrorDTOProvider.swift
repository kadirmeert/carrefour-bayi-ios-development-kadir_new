//
//  APIErrorDTOProvider.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

///It is the error type definition created to be used in the service layer.
enum APIErrorDTOType {
    case standard
}

protocol APIErrorDTOTypeProvider {
    var errorDTOType: APIErrorDTOType { get }
}
