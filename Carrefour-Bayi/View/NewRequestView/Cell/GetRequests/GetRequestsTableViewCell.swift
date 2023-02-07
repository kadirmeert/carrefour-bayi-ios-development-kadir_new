//
//  GetRequestsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Mert on 19.01.2023.
//

import UIKit
import LGButton

protocol GetRequestsTableViewCellDelegate {
    func contentFailedInGetRequest(message: String)
    func deletePurchaseRequestDetailSuccess(isDeleteSucces: Bool)
    func UpdateProductQuantity(vc: UpdateProductQuantityViewController)
    func updateProductQuantitySuccess(isUpdateQuantity: Bool)
}

class GetRequestsTableViewCell: UITableViewCell   {

    
//    MARK: -Properties
    var delegate: GetRequestsTableViewCellDelegate?
    var viewModel = GetRequestTableViewCellViewModel()
    var selectionViewModel = ProductSelectionTableViewCellViewModel()
    var purchaseRequestDetailData: [PurchaseRequestDetailData]?
    var isDeleteSuccess = true
    var isUpdateSuccess = true
    var purchaseRequestId: Int?
    var requestIsHidden: Bool = false
    
    var productAmount: Int?
    var amountMultiplier: Int?
    var maxAmount: Int?
    
    var id: Int?
    var productId: Int?
    var productQuantity: Int?
    var totalAmount = 0.0
    
    
    
//    MARK: -Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestIdLabel: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    func bind(purchaseRequestDetailData: [PurchaseRequestDetailData]?, purchaseRequestId: Int?, productAmount: Int?,
              amountMultiplier: Int?, maxAmount: Int?,  productQuantity: Int?) {
        self.purchaseRequestDetailData = purchaseRequestDetailData
        self.purchaseRequestId = purchaseRequestId
        self.productAmount = productAmount
        self.maxAmount = maxAmount
        
        if self.purchaseRequestDetailData != nil {
            if self.purchaseRequestDetailData?.count == 0 {
                self.requestIdLabel.text = ""
            } else {
                self.requestIdLabel.text = "\(self.purchaseRequestDetailData?[0].RequestId ?? 0)"
            }
        }
        viewModel.delegate = self
        initUI()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        GetRequestsDetailTableViewCell.registerSelf(tableView: tableView)
        tableView.reloadData()
        
        if purchaseRequestDetailData?.count != nil && purchaseRequestDetailData?.count != 0 {
            for i in 0...(purchaseRequestDetailData?.count ?? 0) - 1 {
                if i == 0 {
                    totalAmount = 0
                }
                totalAmount += purchaseRequestDetailData?[i].TotalPrice ?? 0.0
                self.totalPrice.text = "\(totalAmount) TL"
            }
        } else {
            self.totalPrice.text = "0.0 TL"
        }
       
    }
}





//    MARK: - GetRequestsTableViewCell delegate & dataSource
extension GetRequestsTableViewCell: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseRequestDetailData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GetRequestsDetailTableViewCell") as! GetRequestsDetailTableViewCell
        if let requestDetailData = purchaseRequestDetailData?[indexPath.item],
           let maxAmount = maxAmount {
            cell.bind(detailData: requestDetailData, maxAmount: maxAmount, isHidden: requestIsHidden)
            cell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.requestIsHidden == true {
            self.requestIsHidden = false
        } else {
            self.requestIsHidden = true
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
   
}



//    MARK: -GetRequestsDetailTableViewCell Delegate methods
extension GetRequestsTableViewCell: GetRequestsDetailTableViewCellDelegate {
    
    func purchaseRequestUpdate(quantity: Int?, productId: Int?, id: Int?, maxAmount: Int?) {
        let vc : UpdateProductQuantityViewController = UpdateProductQuantityViewController.create(currentQuantity: quantity ?? 0, quantityMultiplier: self.amountMultiplier ?? 0, maxQuantityValue: maxAmount ?? 0)
        vc.delegate = self
        self.delegate?.UpdateProductQuantity(vc: vc)
        
        self.id = id
        self.productId = productId
    }
    
    func purchaseRequestDelete(id: Int?) {
        viewModel.deletePurchaseRequestDetail(id: id ?? 0)
    }
}



//    MARK: GetRequestTableViewCellViewModel Delegate Methods
extension GetRequestsTableViewCell: GetRequestTableViewCellViewModelDelegate {
    func updatePurchaseRequestDetailSuccess() {
        delegate?.updateProductQuantitySuccess(isUpdateQuantity: true)
    }
    
    func deletePurchaseRequestDetailSuccess() {
        delegate?.deletePurchaseRequestDetailSuccess(isDeleteSucces: self.isDeleteSuccess)
    }
    
    func pageContentFailed(message: String) {
        delegate?.contentFailedInGetRequest(message: message)
    }
}



//    MARK: -UpdateProductQuantityViewControllerDelegate Methods
extension GetRequestsTableViewCell: UpdateProductQuantityViewControllerDelegate {
    func updateButtonClicked(quantity: Int) {
        viewModel.updatePurchaseRequestDetail(quantity: quantity , id: self.id ?? 0, productId: self.productId ?? 0)
        
    }
}

