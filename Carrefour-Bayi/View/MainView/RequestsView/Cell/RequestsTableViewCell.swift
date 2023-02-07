//
//  RequestsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import UIKit

protocol RequestsTableViewCellDelegate {
    func requestItemClicked()
}

class RequestsTableViewCell: UITableViewCell {
    // MARK: -Properties
    var delegate: RequestsTableViewCellDelegate?
    
    // MARK: -Views
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    
    func bind(requestModel: PurchaseRequestData) {
        idLabel.text = "\(requestModel.Id ?? 0)"
        requestNumberLabel.text = requestModel.Name
    }
    
//    @IBAction func cellClicked(_ sender: UIButton) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.delegate?.requestItemClicked()
//        }
//    }
}
