//
//  ProductTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 18.12.2022.
//

import UIKit

protocol ProductTableViewCellDelegate {
    func productSelectedButtonTapped(productName: String?, isSelectedProduct: Bool, productId: Int?)
}

class ProductTableViewCell: UITableViewCell {
    
    
//  MARK: -Views-
    
    @IBOutlet weak var productName: UILabel!
    
    
//    MARK: -Properties-

    var delegate : ProductTableViewCellDelegate?
    var isSelectedProduct: Bool = true
    var productId: Int?
    
    func bind(model: String, isSelectedProduct: Bool, ıd: Int) {
        productName.text = model
        productId = ıd
    }
    
    
    @IBAction func productSelectedButtonTapped(_ sender: UIButton) {
        delegate?.productSelectedButtonTapped(productName: productName.text, isSelectedProduct: isSelectedProduct, productId: productId)
    }
}

