//
//  ConnectivityMiddleware.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import Foundation
import Reachability

protocol ConnectivityMiddleware {
    func checkForInternetConnection(_ completion: @escaping (Bool) -> Void)
}

///It is the middle layer that provides internet control.
extension ConnectivityMiddleware {
    func checkForInternetConnection(_ completion: @escaping (Bool) -> Void) {
        do {
            let reachability = try Reachability()
            let status = reachability.connection
            
            completion(status != .unavailable)
        } catch {
            completion(true)
        }
    }
}
