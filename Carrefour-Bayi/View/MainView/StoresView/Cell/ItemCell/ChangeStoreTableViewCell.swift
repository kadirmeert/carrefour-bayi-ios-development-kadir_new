//
//  ChangeStoreTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import UIKit

protocol ChangeStoreTableViewCellDelegate {
    func changeStoreButtonClicked()
}

class ChangeStoreTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var changeAccountButton: UIButton!
    
    // MARK: -Properties
    var delegate: ChangeStoreTableViewCellDelegate?
    
    func bind() {
        
    }
    
    @IBAction func changeAccountButtonClicked(_ sender: UIButton) {
        delegate?.changeStoreButtonClicked()
    }
}
