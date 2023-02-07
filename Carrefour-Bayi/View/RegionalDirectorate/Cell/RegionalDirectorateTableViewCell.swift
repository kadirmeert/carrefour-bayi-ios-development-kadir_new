//
//  RegionalDirectorateTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 13.11.2022.
//

import UIKit

protocol RegionalDirectorateTableViewCellDelegate: AnyObject {
    func deleteClicked()
}
class RegionalDirectorateTableViewCell: UITableViewCell {
    //    MARK: - Properties -
    weak var delegate:  RegionalDirectorateTableViewCellDelegate?
    
    //    MARK: - Views -
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sapNoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    func bind(managerData: RegionalManagerData, isHidden: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        detailView.isHidden = isHidden
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        if let recordDate = dateFormatter.date(from: managerData.InsertDate ?? ""){
            let dateText = dateFormatter1.string(from: recordDate)
            dateLabel.text = dateText
        }
        
        idLabel.text = "ID  \(managerData.Id ?? 0)"
        nameLabel.text = managerData.Username
        surnameLabel.text = managerData.Surname
        sapNoLabel.text = "\(managerData.SAPCode ?? 0)"
        emailLabel.text = managerData.EmailAddress
        storeNameLabel.text = managerData.StoreName
    }

    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        delegate?.deleteClicked()
    }
}
