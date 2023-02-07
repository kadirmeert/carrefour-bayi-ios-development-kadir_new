//
//  AccountingTotalTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import UIKit

class AccountingTotalTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var totalSweepingPrice: UILabel!
    @IBOutlet weak var totalDebt: UILabel!
    @IBOutlet weak var amountToPaid: UILabel!
    
    func bind(item: GetStoreDashboardDetailResponseDTO) {
        totalSweepingPrice.text = "\(item.ToplamSupurmeliPOS?.formattedCurrency ?? "0.0") ₺"
        totalDebt.text = "\(item.ToplamBorc?.formattedCurrency ?? "0.0") ₺"
        amountToPaid.text = "\(item.OdenecekTutar?.formattedCurrency ?? "0.0") ₺"
    }
}
