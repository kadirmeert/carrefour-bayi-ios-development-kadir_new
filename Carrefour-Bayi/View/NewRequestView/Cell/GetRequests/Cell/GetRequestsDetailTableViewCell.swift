//
//  GetRequestsDetailTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Mert on 19.01.2023.
//

import UIKit

protocol GetRequestsDetailTableViewCellDelegate {
    func purchaseRequestDelete(id: Int?)
    func purchaseRequestUpdate(quantity: Int?, productId: Int?, id: Int?, maxAmount: Int?)
}

class GetRequestsDetailTableViewCell: UITableViewCell {

//    MARK: -Properties
    
    var model: [PurchaseRequestDetailData]?
    var delegate: GetRequestsDetailTableViewCellDelegate?
    
    var requestId: Int?
    var quantityValue: Int?
    var productId: Int?
    var id : Int?
    var maxAmount: Int?

    
//    MARK: -Views
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var updateAndDeleteStackView: UIStackView!

    
    func bind(detailData: PurchaseRequestDetailData, maxAmount: Int, isHidden: Bool) {
        self.productName.text = detailData.ProductName
        self.productCode.text = detailData.ProductCode
        self.unitPrice.text = "Fiyat: \(String(describing: detailData.UnitPrice ?? 0.0))"
        self.quantity.text = "Miktar: \(String(describing: detailData.Quantity ?? 0))"
        self.totalPrice.text = "\(String(describing: detailData.TotalPrice ?? 0.0)) TL"
        self.requestId = detailData.RequestId
        self.productId = detailData.ProductId
        self.quantityValue = detailData.Quantity
        self.id = detailData.Id
        self.updateAndDeleteStackView.isHidden = !isHidden
      
     
        self.maxAmount = maxAmount
    }
    
   
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.purchaseRequestDelete(id: self.id)
        
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        delegate?.purchaseRequestUpdate(quantity: self.quantityValue , productId: self.productId, id: self.id, maxAmount: self.maxAmount)
    }
    
    
}
