//
//  SceneDelegate.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 18.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var rootNavController: UINavigationController? {
        get {
            return window?.rootViewController as? UINavigationController
        }
    }
    
    static let shared: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Set root vc
        window = UIWindow(windowScene: scene)
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.overrideUserInterfaceStyle = .light
    }
}




// MARK:- Root VC Provider
extension SceneDelegate {
    private func getRootViewController() -> UIViewController {
        #if MOCK_REPOSITORY
        let launchVC = MainViewController.create(companyAndStoreModel: nil)
        #else
//        let launchVC =   PaymentViewController.create(currentCompanyAndStore: CurrentCompanyAndStore(companyID: 1, storeID: 1, sapCode: 1, companyCode: "221"))
        let launchVC = SplashViewController.create()
//        let launchVC = DedeViewController.create()
        #endif
        
        return wrapWithNavigationController(viewController: launchVC)
    }
    
    private func wrapWithNavigationController(viewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        navController.interactivePopGestureRecognizer?.isEnabled = false
        navController.view.backgroundColor = .white
        return navController
    }
}
