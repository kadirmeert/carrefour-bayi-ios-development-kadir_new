//
//  OrderTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import UIKit

protocol OrderTableViewCellDelegate {
    func orderItemClicked()
}

class OrderTableViewCell: UITableViewCell {
    // MARK: -Properties
    var delegate: OrderTableViewCellDelegate?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        return formatter
    }()
    
    // MARK: -Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func bind(item: OrderData) {
        titleLabel.text = item.Name
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: item.OrderDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        dateLabel.text = dateFormatter.string(from: date ?? Date())
    }
    
}
