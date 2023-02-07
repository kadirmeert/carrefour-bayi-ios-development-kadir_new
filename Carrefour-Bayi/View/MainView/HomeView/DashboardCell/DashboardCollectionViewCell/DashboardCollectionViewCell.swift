//
//  DashboardCollectionViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    // MARK: -Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(item: GetAdvertisementData) {
        titleLabel.text = item.Title
        descriptionLabel.text = item.Description?.description.html2String
    }
}
