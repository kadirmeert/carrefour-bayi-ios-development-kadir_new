//
//  OrderSuggestionTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 27.10.2022.
//

import UIKit

protocol OrderSuggestionTableViewCellDelegate {
    func orderSuggestionClicked()
}

class OrderSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var toDetailButton: UIButton!
    var delegate: OrderSuggestionTableViewCellDelegate?
    
    func bind() {
        // For App Store Review
        toDetailButton.hideOrShowViewByAppStoreReviewState()
        
        self.addShadow()
    }

    @IBAction func toDetailButtonClicked(_ sender: UIButton) {
        delegate?.orderSuggestionClicked()
    }
}
