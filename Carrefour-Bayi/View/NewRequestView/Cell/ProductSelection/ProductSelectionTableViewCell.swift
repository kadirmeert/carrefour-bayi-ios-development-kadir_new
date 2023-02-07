//
//  ProductSelectionTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 16.12.2022.
//

import UIKit
import LGButton

protocol ProductSelectionTableViewCellDelegate {
    func addProductClickedInNewRequest()
    func searchedProductByBarcodeSuccess(response: GetProductByBarcodeResponseDTO)
    func searchedProductByStockCodeSuccess(response: GetProductByStockCodeResponseDTO)
    func productAmountChanged(productAmount: Int)
    func contentFailedInProductSelection(message: String)
    func purchaseRequestDetailData(modelData: [PurchaseRequestDetailData]?)
    func sendPurchaseRequestId(purchaseRequestId: Int)
}



class ProductSelectionTableViewCell: UITableViewCell, UITextFieldDelegate {
  
    
    
    var delegate: ProductSelectionTableViewCellDelegate?
    var viewModel = ProductSelectionTableViewCellViewModel()
    var maxAmount: Int?
    var currentAmount = 0
    var amountMultiplier: Int?
    var isAmountEnable: Bool = false
    
    var purchaseRequestId: Int?
    var productId: String?
    var updateQuantity: Int?
    
    var purchaseRequestDetailData: [PurchaseRequestDetailData]?
    
    //    MARK: - views
    @IBOutlet weak var productQuantityLabel: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var stockCodeTextField: UITextField!
    @IBOutlet weak var productAmountBaseView: BaseView!
    @IBOutlet weak var addProductButton: LGButton!
    @IBOutlet weak var increaseButton: UIButton!
    
    @IBOutlet weak var decreaseButton: UIButton!
    
    func bind(purchaseRequestId: Int?, productId: Int?, isSelectedProduct: Bool, isDeleteSuccess: Bool,
              maximumAmount: Int, amountMultiplier: Int, isUpdateSuccess: Bool, updateQuantity: Int) {
        viewModel.delegate = self
        self.purchaseRequestId = purchaseRequestId
        self.productId = String(describing: productId ?? 0)
        self.isAmountEnable = isSelectedProduct
        self.maxAmount = maximumAmount
//        self.amountMultiplier = (amountMultiplier) * -1
        self.updateQuantity = updateQuantity
        
        if self.isAmountEnable == true {
            self.enableAmountChanger()
            self.isAmountEnable = true
            self.currentAmount = 0
            self.productQuantityLabel.text = ""
        } else {
            self.disableAmountChanger()
        }
        
        if isDeleteSuccess == true {
            createPurchaseRequestDetailSuccess()
        }
        
        if isUpdateSuccess == true {
            createPurchaseRequestDetailSuccess()
        }
        
        initUI()
    }

    private func initUI() {
        productQuantityLabel.layer.cornerRadius = 8
        productQuantityLabel.layer.masksToBounds = true
        
        barcodeTextField.layer.cornerRadius = 10
        barcodeTextField.layer.masksToBounds = true
        barcodeTextField.setLeftPaddingPoints(15)
        
        stockCodeTextField.layer.cornerRadius = 10
        stockCodeTextField.layer.masksToBounds = true
        stockCodeTextField.setLeftPaddingPoints(15)
        
        self.productQuantityLabel.delegate = self
        self.productQuantityLabel.attributedPlaceholder =  NSAttributedString(string:"Lütfen Miktar Giriniz", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font :UIFont(name: "Montserrat-Medium", size: 11)!])
        
        
        if self.updateQuantity != 0 {
            viewModel.createPurchaseRequestDetail(productId: productId ?? "", PurchaseRequestId: purchaseRequestId ?? 0, quantity: self.updateQuantity ?? 0)
        }
    }
  
    
    func enableAmountChanger() {
        productAmountBaseView.isUserInteractionEnabled = true
        productAmountBaseView.alpha = 1
        addProductButton.isUserInteractionEnabled = true
        addProductButton.alpha = 1
        isAmountEnable = true
    }
    func disableAmountChanger() {
        productAmountBaseView.isUserInteractionEnabled = false
        productAmountBaseView.alpha = 0.5
        addProductButton.isUserInteractionEnabled = false
        addProductButton.alpha = 0.5
    }
    
    
    @IBAction func addProductClicked(_ sender: LGButton) {
   
        viewModel.createPurchaseRequestDetail(productId: productId ?? "", PurchaseRequestId: purchaseRequestId ?? 0, quantity: self.currentAmount)
        self.delegate?.sendPurchaseRequestId(purchaseRequestId: self.purchaseRequestId ?? 0)
    }
    
    
    @IBAction func searchProductClicked(_ sender: LGButton) {
        if let barcodeText = barcodeTextField.text, barcodeText != "" {
            viewModel.searchProductByBarcodeCode(barcodeCode: barcodeText)
        } else {
            if let stockCodeText = stockCodeTextField.text, stockCodeText != "" {
                viewModel.searchProductByStockCode(stockCode: stockCodeText)
            } else {
                delegate?.contentFailedInProductSelection(message: "Lütfen Barkod veya Stok Kodu alanını doldurunuz")
            }
        }
    }
    
    @IBAction func productQuantityEditingChanged(_ sender: UITextField) {
        self.productQuantityLabel.text = sender.text
        if Int(self.productQuantityLabel.text ?? "") ?? 0 > maxAmount ?? 0 {
            self.productQuantityLabel.text = "\(maxAmount ?? 0)"
        }
        self.currentAmount = Int(self.productQuantityLabel.text ?? "") ?? 0
      
    }
    
//    @IBAction func productQuantityEditingBegin(_ sender: Any) {
//        self.productQuantityLabel.resignFirstResponder()
//        self.productQuantityLabel.text = ""
//    }
    
//    @IBAction func decreaseProductAmountClicked(_ sender: Any) {
//
//        if currentAmount  <= 0 {
//            currentAmount = 0
//        }
//        if let amountMultiplier {
//            if (currentAmount - amountMultiplier) >= 0 {
//                currentAmount -= amountMultiplier
//                productQuantityLabel.text = "\(currentAmount)"
//                delegate?.productAmountChanged(productAmount: currentAmount)
//            }
//        }
//    }
//
//
//    @IBAction func increaseProductAmountClicked(_ sender: Any) {
//        if let amountMultiplier, let maxAmount {
//            if (currentAmount + amountMultiplier) <= maxAmount {
//                currentAmount += amountMultiplier
//                productQuantityLabel.text = "\(currentAmount)"
//                delegate?.productAmountChanged(productAmount: currentAmount)
//            }
//        }
//    }
}





//    MARK: - ProductSelection TableViewCell ViewModelDelegate methods
extension ProductSelectionTableViewCell: ProductSelectionTableViewCellViewModelDelegate {
    func getPurchaseRequestDetailSuccess(modelData: [PurchaseRequestDetailData]?) {
        self.purchaseRequestDetailData = modelData
        self.delegate?.purchaseRequestDetailData(modelData: self.purchaseRequestDetailData)
    }
    
    func createPurchaseRequestDetailSuccess() {
        viewModel.getPurchaseRequestDetail(purchaseRequestId: purchaseRequestId ?? 0)
    }
    
    func searchingByStockSuccess() {
        
    }
    
    func searchingByBarcodeSuccess() {
        
        
    }
    
    func pageContentFailed(message: String) {
        delegate?.contentFailedInProductSelection(message: message)
    }
}








