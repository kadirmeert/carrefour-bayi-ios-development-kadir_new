//
//  ReportItemTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 15.09.2022.
//

import UIKit

class ReportItemTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var itemLabel: UILabel!
    
    func bind(menuItemTitle: String) {
        itemLabel.text = menuItemTitle
    }
}
