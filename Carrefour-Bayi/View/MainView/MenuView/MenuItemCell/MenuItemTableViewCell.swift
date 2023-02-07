//
//  MenuItemTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 22.08.2022.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDetailImageView: UIImageView!
    
    func bind(menuItem: MenuItem) {
        itemImageView.image = UIImage(named: menuItem.menuIcon)
        
        itemTitle.text = menuItem.menuTitle
        
        itemDetailImageView.isHidden = menuItem.hasDetail ? false : true
    }
}
