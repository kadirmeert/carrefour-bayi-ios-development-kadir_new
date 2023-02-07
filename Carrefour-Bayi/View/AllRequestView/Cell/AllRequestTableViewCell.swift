//
//  AllRequestTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import UIKit

protocol AllRequestTableViewCellDelegate {
    func requestDetailsClicked()
    func deleteRequestClicked(id: Int?)
    func editRequestClicked()
}

class AllRequestTableViewCell: UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //    MARK: - Properties -
    var delegate: AllRequestTableViewCellDelegate?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    var id: Int?
    
    //    MARK: - Views -
    @IBOutlet weak var editRequestView: UIView!
    @IBOutlet weak var deleteRequestView: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingStateLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var waitingYellowView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint!
    func bind(requestData: PurchaseRequestData, isHidden: Bool) {
        // For App Store Review
//        editRequestView.hideOrShowViewByAppStoreReviewState()
//        deleteRequestView.hideOrShowViewByAppStoreReviewState()
        self.id = requestData.Id ?? 0
        
        detailView.isHidden = isHidden
        detailViewHeightConstraint.constant = isHidden ? 0 : 165
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        if let recordDate = dateFormatter.date(from: requestData.RequestDate!){
            let dateText = dateFormatter1.string(from: recordDate)
            dateLabel.text = dateText
        }
        idLabel.text = "ID  \(requestData.Id ?? 0)"
        requestNumberLabel.text = requestData.Name
        totalPriceLabel.text = "\(requestData.TotalPrice?.formattedCurrency ?? "0") ₺"
        waitingStateLabel.text = requestData.StateCodeValue
        if requestData.StateCode == 2 {
        
        }
        switch requestData.StateCode {
        case 0:
            separatorView.backgroundColor = .primaryRed
            waitingYellowView.backgroundColor = .primaryRed
            self.deleteRequestView.isHidden = isHidden
            self.editRequestView.isHidden = isHidden
        case 1:
            separatorView.backgroundColor = .primaryYellow
            waitingYellowView.backgroundColor = .primaryYellow
            self.deleteRequestView.isHidden = isHidden
            self.editRequestView.isHidden = isHidden
        case 2:
            separatorView.backgroundColor = .primaryDarkBlue
            waitingYellowView.backgroundColor = .primaryDarkBlue
            self.deleteRequestView.isHidden = !isHidden
            self.editRequestView.isHidden = !isHidden
        default:
            break
        }
        initUI()
        
        
    }
    
    private func initUI() {
        waitingView.layer.borderColor = UIColor.primaryLightBlue.cgColor
        waitingView.layer.borderWidth = 1
        waitingYellowView.layer.cornerRadius = waitingYellowView.frame.width / 2
    }
    
    @IBAction func requestDetailsClicked(_ sender: UIButton) {
        delegate?.requestDetailsClicked()
    }
    
    @IBAction func deleteRequestClicked(_ sender: UIButton) {
        delegate?.deleteRequestClicked(id: self.id)
    }
    
    @IBAction func editRequestClicked(_ sender: UIButton) {
        delegate?.editRequestClicked()
    }
    
}
