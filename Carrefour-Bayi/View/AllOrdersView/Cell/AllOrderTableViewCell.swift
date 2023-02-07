//
//  AllOrderTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import UIKit

protocol AllOrderTableViewCellDelegate {
    func orderDetailsClicked()
}

class AllOrderTableViewCell: UITableViewCell {

    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
  //    MARK: - Properties -
    var delegate: AllOrderTableViewCellDelegate?
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    
    //    MARK: - Views -
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var waitingStateLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var waitingYellowView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint!
    
    
    
    func bind(orderData: OrderData, isHidden: Bool) {
        detailView.isHidden = isHidden
        detailViewHeightConstraint.constant = isHidden ? 0 : 156
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        
        if let recordDate = dateFormatter.date(from: orderData.OrderDate){
            let dateText = dateFormatter1.string(from: recordDate)
            dateLabel.text = dateText
        }
        idLabel.text = "ID  \(orderData.Id)"
        requestNumberLabel.text = orderData.Name
        totalPriceLabel.text = "\(orderData.TotalPrice.formattedCurrency) ₺"
        switch orderData.StateCode {
            case 0:
                seperatorView.backgroundColor = .primaryYellow
                waitingYellowView.backgroundColor = .primaryYellow
                waitingStateLabel.text = "Siparişiniz Alındı"
            case 1:
                seperatorView.backgroundColor = .primaryDarkBlue
                waitingYellowView.backgroundColor = .primaryDarkBlue
                waitingStateLabel.text = "Siparişiniz Alındı"
            case 2:
                seperatorView.backgroundColor = .primaryRed
                waitingYellowView.backgroundColor = .primaryRed
                waitingStateLabel.text = "Siparişiniz Alındı"
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
    
    @IBAction func orderDetailsClicked(_ sender: UIButton) {
        delegate?.orderDetailsClicked()
    }
    
}
