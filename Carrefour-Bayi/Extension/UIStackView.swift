//
//  UIStackView.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import UIKit

class BaseStackView: UIStackView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
}
