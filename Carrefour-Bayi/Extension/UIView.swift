//
//  UIView.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 27.09.2022.
//

import UIKit


extension UIView {
    
    func addShadow(cornerRadius: CGFloat = 16,
                   shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        }
    
    func addShadowWithoutCorner(cornerRadius: CGFloat = 10,
                   shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.7),
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0),
                   shadowOpacity: Float = 0.75,
                   shadowRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
//    func addShadow(cornerRadius: CGFloat = 16,
//                   shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
//                   shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0),
//                   shadowOpacity: Float = 0.4,
//                   shadowRadius: CGFloat = 5,
//                   maskedCorners: CACornerMask = [.layerMaxXMaxYCorner,
//                                                                             .layerMaxXMinYCorner,
//                                                                             .layerMinXMaxYCorner,
//                                                                             .layerMinXMinYCorner]) {
//        layer.cornerRadius = cornerRadius
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//        layer.maskedCorners = maskedCorners
//    }
    
    /// Hide view if the app in review or show view if the app not in review
    func hideOrShowViewByAppStoreReviewState() {
        self.alpha = Constant.isTheAppUnderReview ? 0.0 : 1.0
        self.isUserInteractionEnabled = Constant.isTheAppUnderReview ? false : true
    }
    
}

