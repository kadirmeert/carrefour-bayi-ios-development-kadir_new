//
//  MasterPassMethodType.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 21.01.2023.
//

import Foundation


enum MasterPassMethodType: String {
    case directPurchase       = "DIRECT_PURCHASE"
    case registerPurchase     = "REGISTER_PURCHASE"
    case purchase             = "PURCHASE"
    case completeRegistration = "COMPLETE_REGISTRATION"
    case linkCardToClient     = "LINK_CARD_TO_CLIENT"
}
