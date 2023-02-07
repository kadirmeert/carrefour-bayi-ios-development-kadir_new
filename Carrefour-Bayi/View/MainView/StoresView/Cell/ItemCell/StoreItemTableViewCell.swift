//
//  StoreItemTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import UIKit

class StoreTableSection {
    var isSelected: Bool = false
    var isActive: Bool = false
    var storeItem: StoreItem
    
    init(isSelected: Bool = false, isActive: Bool = false, storeItem: StoreItem) {
        self.isSelected = isSelected
        self.isActive = isActive
        self.storeItem = storeItem
    }
}

class StoreItemTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var containerView: BaseView!
    @IBOutlet weak var storeIdLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var cellIconImageView: UIImageView!
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var unselectedView: BaseView!
    
    func bind(section: StoreTableSection) {
        containerView.backgroundColor = section.isSelected ? .primaryDarkBlue : .primaryLightGray
        
        storeIdLabel.textColor = section.isSelected ? .white : .primaryTitleBlue
        
        storeNameLabel.textColor = section.isSelected ? .white : .primaryTitleBlue
        
        selectedView.isHidden = !section.isActive
        unselectedView.isHidden = section.isActive
        
        storeIdLabel.text = section.storeItem.SAPCode
        storeNameLabel.text = section.storeItem.Name
    }
}
