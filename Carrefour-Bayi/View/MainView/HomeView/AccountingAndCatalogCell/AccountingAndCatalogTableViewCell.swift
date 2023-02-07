//
//  AccountingAndCatalogTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.08.2022.
//

import UIKit

protocol AccountingAndCatalogTableViewCellDelegate {
    func accountingButtonClicked()
    func catalogButtonClicked()
}

class AccountingAndCatalogTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var accountingView: BaseView!
    @IBOutlet weak var catalogView: BaseView!
    
    // MARK: -Properties
    var delegate: AccountingAndCatalogTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind() {
        self.addShadow()
    }
    
    @IBAction func accountingButtonClicked(_ sender: UIButton) {
        delegate?.accountingButtonClicked()
    }
    
    @IBAction func catalogButtonClicked(_ sender: UIButton) {
        delegate?.catalogButtonClicked()
    }
}
