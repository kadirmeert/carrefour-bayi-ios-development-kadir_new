//
//  ProductResultsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.12.2022.
//

import UIKit

class ProductResultsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var selectedCircleButton: UIImageView!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productCodeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var aisleCodeLabel: UILabel!
    @IBOutlet weak var availableDaysLabel: UILabel!
    
    
    func bind(model: ProductModel, isHidden: Bool) {
        setHiddenViews(isHidden: isHidden)
        productCodeLabel.text = model.StokKodu
        productPriceLabel.text = "\(model.Price ?? 0.0)"
        aisleCodeLabel.text = "\(model.ReyonKodu ?? 0)"
        productName.text = model.StokAdi
        availableDaysLabel.text = model.SiparisGunleri
    }
    
    
    private func setHiddenViews(isHidden: Bool) {
        detailView.isHidden = isHidden
        if isHidden {
            arrowImage.image = UIImage(named: "arrow_down-colorful")
            selectedCircleButton.image = UIImage(systemName: "circlebadge")
        } else {
            arrowImage.image = UIImage(named: "arrow_up-colorful")
            selectedCircleButton.image = UIImage(systemName: "circlebadge.fill")
        }
    }
    
}
