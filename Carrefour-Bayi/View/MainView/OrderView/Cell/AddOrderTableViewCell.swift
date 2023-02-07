//
//  AddOrderTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import UIKit

protocol AddOrderTableViewCellDelegate {
    func addOrderClicked()
}

class AddOrderTableViewCell: UITableViewCell {
    // MARK: -Properties
    
    @IBOutlet weak var addOrderButton: BaseView!
    var delegate: AddOrderTableViewCellDelegate?
    
    // MARK: -Views
    
    func bind() {
        // For App Store Review
        addOrderButton.hideOrShowViewByAppStoreReviewState()
        
//        addOrderButton.addShadow()
    }
    
    @IBAction func cellClicked(_ sender: UIButton) {
        delegate?.addOrderClicked()
    }
}
