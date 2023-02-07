//
//  GiftCardTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.08.2022.
//

import UIKit

protocol GiftCardTableViewCellDelegate {
    func giftCardButtonClicked()
}

class GiftCardTableViewCell: UITableViewCell {
    // MARK: -Properties
    var delegate: GiftCardTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind() {
        self.addShadow()
    }
    
    @IBAction func giftCardClicked(_ sender: UIButton) {
        delegate?.giftCardButtonClicked()
    }
}
