//
//  ServiceConfiguration.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation

///For the use of APIs of test or live environments.
class ServiceConfiguration {
    #if DEBUG
    /// live
//    static let apiBaseURL: URL = URL(string: "https://appapi.carrefoursa.com")!
    /// test
    static let apiBaseURL: URL = URL(string: "http://10.85.176.31:1212")!

    static let Language: String = "tr"
    static let ProcessType: Int = 2
    static let AuthDeviceUsername: String = "publicios"
    static let AuthDevicePassword: String = "te3y9G+Dv6Yp0EmN_*vN"
    static let MasterPassMode: String = "Test"
    #else
    /// live
//    static let apiBaseURL: URL = URL(string: "https://appapi.carrefoursa.com")!
    /// test
    static let apiBaseURL: URL = URL(string: "http://10.85.176.31:1212")!
    
    static let Language: String = "tr"
    static let ProcessType: Int = 2
    static let AuthDeviceUsername: String = "publicios"
    static let AuthDevicePassword: String = "te3y9G+Dv6Yp0EmN_*vN"
    static let MasterPassMode: String = "Test"
    #endif
}
