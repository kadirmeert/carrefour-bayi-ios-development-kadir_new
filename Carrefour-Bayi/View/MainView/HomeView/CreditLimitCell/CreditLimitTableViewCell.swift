//
//  CreditLimitTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import UIKit

protocol CreditLimitTableViewCellDelegate {
    func navigateToCreditDetail()
}

class CreditLimitTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var totalLimitLabel: UILabel!
    @IBOutlet weak var usedLimitLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var remainingLimit: UILabel!
    
    // MARK: -Properties
    var delegate: CreditLimitTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind(creditLimitModel: GetCreditLimitResponseDTO) {
        UIView.animate(withDuration: 0.5) {
            self.addShadow()
            self.progressView.alpha = 1
            self.progressView.layer.cornerRadius = 5
            self.progressView.clipsToBounds = true
        }
        
        let transform = CGAffineTransform(scaleX: 1.0, y: 2.2)
        progressView.transform = transform
        
        totalLimitLabel.text = "\(creditLimitModel.TotalLimit?.formattedCurrency ?? "0.0") ₺"
        usedLimitLabel.text = "% \(Int(creditLimitModel.UsedLimit ?? 0) )"
        remainingLimit.text = "\(creditLimitModel.RemainingLimit?.formattedCurrency ?? "0.0") ₺"
        
        progressView.progress = Float(creditLimitModel.UsedLimit ?? 0.0) / 100
    }
    
    @IBAction func currentButtonClicked(_ sender: UIButton) {
        delegate?.navigateToCreditDetail()
    }
}
