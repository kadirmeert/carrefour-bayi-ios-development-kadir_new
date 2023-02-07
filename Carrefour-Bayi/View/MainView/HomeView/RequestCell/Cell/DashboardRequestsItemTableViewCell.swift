//
//  DashboardRequestsItemTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.08.2022.
//

import UIKit

class DashboardRequestsItemTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var requestNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusView: BaseView!
    
    // MARK: -Properties
    var requestModel: PurchaseRequestData?
    
    // MARK: -UI Methods
    func bind(requestModel: PurchaseRequestData) {
        self.requestModel = requestModel
        idLabel.text = "\(requestModel.Id ?? 0)"
        requestNameLabel.text = requestModel.Name
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        
        if let date = dateFormatterGet.date(from: requestModel.RequestDate ?? "") {
            dateLabel.text = dateFormatterPrint.string(from: date)
        }
        
        priceLabel.text = "\(requestModel.TotalPrice?.formattedCurrency ?? "") ₺"
        
        /// Aşağıdaki marka yorumuna göre yazılmıştır.
        /// 1 ise "Talebi Göndermediniz" olup sarı renkte olur. 2 ise "Talebiniz Alındı" olup mavi renkte olur. 0 ise net değil ancak kırmızı renk kullanıyoruz.
        if requestModel.StateCode == 0 {
            statusView.backgroundColor = .primaryRed
        }
        else if requestModel.StateCode == 1 {
            statusView.backgroundColor = .primaryYellow
        }
        else if requestModel.StateCode == 2 {
            statusView.backgroundColor = .primaryDarkBlue
        }
    }
}
