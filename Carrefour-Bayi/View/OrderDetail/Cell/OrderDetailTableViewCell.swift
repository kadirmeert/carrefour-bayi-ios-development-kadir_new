//
//  OrderDetailTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 11.11.2022.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    //    MARK: - Views -
    
    @IBOutlet weak var productNumber: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    
    func bindOrder(orderDetailData: OrderDetailData) {
        productNumber.text = "\(orderDetailData.ProductId ?? "-")"
        productName.text = "\(orderDetailData.ProductName ?? "-")"
        productQuantity.text = "\(orderDetailData.Quantity ?? 0)"
        productPrice.text = "\((orderDetailData.UnitPrice ?? 0.0).formattedCurrency) ₺"
        totalPrice.text = "\((orderDetailData.TotalPrice ?? 0.0).formattedCurrency) ₺"
    }
    
    func bindRequestDetail(requestDetailData: PurchaseRequestDetailData) {
        productNumber.text = requestDetailData.ProductCode
        productName.text = "\(requestDetailData.ProductName ?? "-")"
        productQuantity.text = "\(requestDetailData.Quantity ?? 0)"
        productPrice.text = "\((requestDetailData.UnitPrice ?? 0.0).formattedCurrency) ₺"
        totalPrice.text = "\((requestDetailData.TotalPrice ?? 0.0).formattedCurrency) ₺"
    }
    
}
