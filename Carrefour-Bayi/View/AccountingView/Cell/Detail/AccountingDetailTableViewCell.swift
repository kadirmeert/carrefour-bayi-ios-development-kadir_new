//
//  AccountingDetailTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import UIKit

protocol AccountingDetailTableViewCellDelegate {
    func detailButtonClicked()
}

class AccountingDetailTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var guaranteeLabel: UILabel!
    @IBOutlet weak var duePriceLabel: UILabel!
    @IBOutlet weak var exceedingGuaranteePriceLabel: UILabel!
    @IBOutlet weak var openOrderPriceLabel: UILabel!
    
    // MARK: -Properties
    var delegate: AccountingDetailTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind(item: GetStoreDashboardDetailResponseDTO) {
        guaranteeLabel.sizeToFit()
        duePriceLabel.sizeToFit()
        exceedingGuaranteePriceLabel.sizeToFit()
        openOrderPriceLabel.sizeToFit()
        guaranteeLabel.text = "\(item.TeminatMektubu?.formattedCurrency ?? "0.0") ₺"
        duePriceLabel.text = "\(item.VadesiGecmisTutar?.formattedCurrency ?? "0.0") ₺"
        exceedingGuaranteePriceLabel.text = "\(item.TeminatiAsanTutar?.formattedCurrency ?? "0.0") ₺"
        openOrderPriceLabel.text = "\(item.AcikSiparisToplami?.formattedCurrency ?? "0.0") ₺"
    }
    
    @IBAction func accountingDetailButtonClicked(_ sender: UIButton) {
        delegate?.detailButtonClicked()
    }
}
