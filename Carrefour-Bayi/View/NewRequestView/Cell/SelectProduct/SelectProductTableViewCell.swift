//
//  SelectProductTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.12.2022.
//

import UIKit
import LGButton

protocol SelectProductTableViewCellDelegate {
    func productButtonToggled(productName: String?)
    func productByProductModelId(productId: Int?, isSelectedProduct: Bool?)
    func productSelectionRemoved()
}

class SelectProductTableViewCell: UITableViewCell {
    
    
    //    MARK: -Views
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productView: UIView!
    
    @IBOutlet weak var selectedProductLabel: UILabel!
    @IBOutlet weak var selectedProductButton: UIButton!
    @IBOutlet weak var selectedProductView: UIView!
    
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var unitsPerPackage: UILabel!
    @IBOutlet weak var maximumAmount: UILabel!
    @IBOutlet weak var storeStock: UILabel!
    @IBOutlet weak var infoProductView: BaseView!
    
    @IBOutlet weak var mondayInfo: UILabel!
    @IBOutlet weak var tuesdayInfo: UILabel!
    @IBOutlet weak var wednesdayInfo: UILabel!
    @IBOutlet weak var thursdayInfo: UILabel!
    @IBOutlet weak var fridayInfo: UILabel!
    @IBOutlet weak var saturdayInfo: UILabel!
    @IBOutlet weak var sundayInfo: UILabel!
    
    
    //    MARK: - Properties
    private var productByProductModelName: Array = [String]()
    private var productByProductModelArray: Array = [String]()
    private var productByProductModelCount: Int?
    private var productByProductModelId: Array = [Int]()
    
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    var delegate : SelectProductTableViewCellDelegate?
    
    var isSelectedProduct: Bool = false
    
    var infoProductFromStockId: ProductModel?
    var isInfoNotSuccess: Bool = false
        
    func bind (filteredProductModelName: [String], isSelectedAisle: Bool, selectedProductName: String, selectedProductId: Int, filteredProductModelId: [Int], infoProductFromStockId: ProductModel?, isSelectedProduct: Bool, isInfoNotSuccess: Bool ) {
        self.infoProductFromStockId = infoProductFromStockId
        productByProductModelName = filteredProductModelName
        productByProductModelId = filteredProductModelId
        self.isSelectedProduct = isSelectedProduct
        tableView.isHidden = isSelectedAisle
        self.isInfoNotSuccess = isInfoNotSuccess
     
        if isSelectedAisle == true && self.isSelectedProduct == true  {
            selectedProductView.isHidden = !isSelectedAisle
            infoProductView.isHidden = !isSelectedAisle
            selectedProductLabel.text = selectedProductName
        }
        
        if isInfoNotSuccess == true {
            stockCode.text = ""
            stockName.text = ""
            unitsPerPackage.text = ""
            maximumAmount.text = ""
            storeStock.text = ""
            mondayInfo.text = ""
            tuesdayInfo.text = ""
            wednesdayInfo.text = ""
            thursdayInfo.text = ""
            fridayInfo.text = ""
            saturdayInfo.text = ""
            sundayInfo.text = ""
        } else {
            stockCode.text = infoProductFromStockId?.StokKodu
            stockName.text = infoProductFromStockId?.StokAdi
            unitsPerPackage.text = "\((infoProductFromStockId?.sto_birim2_katsayi ?? 0.0) * -1)"
            maximumAmount.text = "\(infoProductFromStockId?.sto_prim_orani ?? 0)"
            storeStock.text = "\( infoProductFromStockId?.Miktar ?? 0.0) \(infoProductFromStockId?.Birim ?? "")"
        }

        if isSelectedProduct == false {
            selectedProductView.isHidden = !isSelectedProduct
            infoProductView.isHidden = !isSelectedProduct
        }
        initUI()
    }
  
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        productView.alpha = 1
        productView.isUserInteractionEnabled = true
        ProductTableViewCell.registerSelf(tableView: tableView)
        
        if infoProductFromStockId?.Pazartesi == 1 {
            mondayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            mondayInfo.text =  ""
        }
        if infoProductFromStockId?.Sali == 1 {
            tuesdayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            tuesdayInfo.text =  ""
        }
        if infoProductFromStockId?.Carsamba == 1 {
            wednesdayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            wednesdayInfo.text =  ""
        }
        if infoProductFromStockId?.Persembe == 1 {
            thursdayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            thursdayInfo.text =  ""
        }
        if infoProductFromStockId?.Cuma == 1 {
            fridayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            fridayInfo.text =  ""
        }
        if infoProductFromStockId?.Cumartesi == 1 {
            saturdayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            saturdayInfo.text =  ""
        }
        if infoProductFromStockId?.Pazar == 1 {
            sundayInfo.text = "Bu talebe eklenebilir. ✓"
        } else {
            sundayInfo.text =  ""
        }

        tableView.reloadData()
    }
    
    
    @IBAction func productButtonTapped(_ sender: UIButton) {
        delegate?.productButtonToggled(productName: selectedProductLabel.text)

    }
    
    @IBAction func selectedProductButtonTapped(_ sender: Any) {
        selectedProductView.isHidden = !self.isSelectedProduct
        infoProductView.isHidden = !self.isSelectedProduct
        delegate?.productSelectionRemoved()
        productButtonTapped(productButton)
    }
}


//  MARK: -Product TableViewCellDelegate methods
extension SelectProductTableViewCell: ProductTableViewCellDelegate {
    
    func productSelectedButtonTapped(productName: String?, isSelectedProduct: Bool, productId: Int?) {
        selectedProductLabel.text = productName
        delegate?.productByProductModelId(productId: productId, isSelectedProduct: isSelectedProduct)
        productButtonTapped(productButton)
        
    }
}




//    MARK: - TableView DataSource & Delegate
extension SelectProductTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productByProductModelName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        cell.bind(model: productByProductModelName[indexPath.item], isSelectedProduct: isSelectedProduct, ıd: productByProductModelId[indexPath.item])
        cell.delegate = self

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}



