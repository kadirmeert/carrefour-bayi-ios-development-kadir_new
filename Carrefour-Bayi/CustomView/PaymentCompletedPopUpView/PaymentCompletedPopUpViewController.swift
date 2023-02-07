//
//  PaymentCompletedPopUpViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 26.01.2023.
//

import UIKit

class PaymentCompletedPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
}






//    MARK: - Creator
extension PaymentCompletedPopUpViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "PaymentCompletedPopUpViewController"
        }
    }
    
    class func create() -> PaymentCompletedPopUpViewController {
        let vc: PaymentCompletedPopUpViewController = PaymentCompletedPopUpViewController.instantiateFromNib()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
