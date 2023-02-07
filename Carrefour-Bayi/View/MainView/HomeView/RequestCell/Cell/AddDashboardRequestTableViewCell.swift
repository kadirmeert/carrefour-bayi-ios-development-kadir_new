//
//  AddDashboardRequestTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.08.2022.
//

import UIKit

protocol AddDashboardRequestTableViewCellDelegate {
    func addRequestClicked()
}

class AddDashboardRequestTableViewCell: UITableViewCell {
    
    // MARK: -Properties
    
    @IBOutlet weak var addRequestBaseView: UIView!
    var delegate: AddDashboardRequestTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind() {
        // For App Store Review
        addRequestBaseView.hideOrShowViewByAppStoreReviewState()
        
        self.addShadow()
    }
    
    @IBAction func addRequestButtonClicked(_ sender: UIButton) {
        delegate?.addRequestClicked()
    }
}
