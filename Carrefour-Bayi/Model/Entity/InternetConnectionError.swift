//
//  InternetConnectionError.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

struct InternetConnectionError: APIErrorMessageProvider {
    var messageText: String? = "noInternetMessage".localized
}
