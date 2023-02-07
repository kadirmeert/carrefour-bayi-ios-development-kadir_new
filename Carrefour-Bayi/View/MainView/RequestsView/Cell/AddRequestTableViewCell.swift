//
//  AddRequestTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import UIKit

protocol AddRequestTableViewCellDelegate {
    func addRequestClicked()
}

class AddRequestTableViewCell: UITableViewCell {
    // MARK: -Properties
    var delegate: AddRequestTableViewCellDelegate?
    @IBOutlet weak var addRequestButton: BaseView!
    
    func bind() {
        // For App Store Review
        addRequestButton.hideOrShowViewByAppStoreReviewState()
        
//        addRequestButton.addShadow()
    }
    
    @IBAction func cellClicked(_ sender: UIButton) {
        delegate?.addRequestClicked()
    }
}
