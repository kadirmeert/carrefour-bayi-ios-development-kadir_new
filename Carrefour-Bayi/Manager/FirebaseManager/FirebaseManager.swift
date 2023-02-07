//
//  FirebaseManager.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 5.12.2022.
//

import Foundation
import FirebaseRemoteConfig


class FirebaseManager {
    
    func fetchRemoteConfigValues() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // 12 * 60 * 60
        remoteConfig.configSettings = settings
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success && error == nil {
                remoteConfig.activate { _, error in
                    guard error == nil else {
                        return
                    }
#if DEBUG
                    print("VEYSEL <<<< remote config çalışıyor -> ")
#endif
                    let remoteIsTestForAppStoreValue: Bool = remoteConfig.configValue(forKey: "isTheAppUnderReview").boolValue
                    
                    /// this code line is must be under comment when getting build for app store
//                    Constant.isTheAppUnderReview = remoteIsTestForAppStoreValue
                }
            }
        }
    }
}
