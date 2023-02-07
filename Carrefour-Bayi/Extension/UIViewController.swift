//
//  UIViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation
import UIKit
import SafariServices

public extension UIViewController {
    typealias XibVC = UIViewController & XibNameProvider
    static func instantiateFromNib<T: XibVC>() -> T {
        return T.init(nibName: T.xibName, bundle: Bundle(for: T.self))
    }
}

public extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Tamam", style: .default) { act in
            completion?()
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showErrorAlert(message: String,
                        dismissParent: Bool = false,
                        customAction: UIAlertAction? = nil,
                        additionalAction: UIAlertAction? = nil) {
        if let cA = customAction {
            showAlert(title: "error".localized, message: message, actions: [cA])
        }
        else {
            let action = UIAlertAction(title: "done".localized, style: .default) { (action) in
                if dismissParent {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                        if let navC = self?.navigationController {
                            navC.popViewController(animated: true)
                        }
                        else {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            
            if let adAction = additionalAction {
                showAlert(title: "error".localized, message: message, actions: [adAction, action])
            }
            else {
                showAlert(title: "error".localized, message: message, actions: [action])
            }
        }
    }
    func addSubView(subViewController: UIViewController, on view: UIView, height: CGFloat) {
        view.addSubview(subViewController.view)
        subViewController.view.translatesAutoresizingMaskIntoConstraints = false
        subViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        subViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = false
        subViewController.view.heightAnchor.constraint(equalToConstant: height).isActive = true
        subViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}



extension UIViewController {
    func navigateToUrl(_ url: URL){
//        if url.isDeeplink {
//            if DeeplinkNavigator.shared.pushDeeplink(deeplink: url.absoluteString) {
//                NotificationCenter.default.post(name: .handleDeeplink, object: nil)
//            }
//        }
//        else if !url.isHttp && UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//        else {
//            let safariVC = SFSafariViewController(url: url)
//            self.present(safariVC, animated: true, completion: nil)
//        }
    }
}




extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        let frame = self.view.frame
        view.removeFromSuperview()
        view = nil
        self.view.frame = frame
        parent?.addSubview(view)
    }
}

