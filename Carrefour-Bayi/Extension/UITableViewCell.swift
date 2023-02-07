//
//  UITableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    class func registerSelf(tableView: UITableView) {
        let nib = UINib(nibName: self.className, bundle: Bundle(for: self))
        tableView.register(nib, forCellReuseIdentifier: self.className)
    }
}

