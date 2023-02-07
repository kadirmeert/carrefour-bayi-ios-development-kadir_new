//
//  CovidPrecautionsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.08.2022.
//

import UIKit

protocol CovidPrecautionsTableViewCellDelegate {
    func covidPrecautionsClicked()
}

class CovidPrecautionsTableViewCell: UITableViewCell {
    // MARK: -Properties
    var delegate: CovidPrecautionsTableViewCellDelegate?
    
    func bind() {
        self.addShadow()
    }
    
    @IBAction func covidPrecautionsClicked(_ sender: UIButton) {
        delegate?.covidPrecautionsClicked()
    }
}
