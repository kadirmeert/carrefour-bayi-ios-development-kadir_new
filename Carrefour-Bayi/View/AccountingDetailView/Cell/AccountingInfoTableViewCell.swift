//
//  AccountingInfoTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import UIKit

class AccountingInfoTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recordNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var invoiceDescriptionLabel: UILabel!
    @IBOutlet weak var referenceNoLabel: UILabel!
    @IBOutlet weak var documentNoLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var invoiceDateLabel: UILabel!
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var receivableLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    // MARK: -Properties
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
    
    func bind(accountingRecord: AccountingRecord ,isHidden: Bool) {
        infoView.isHidden = isHidden
        
        if let date = accountingRecord.Date, let recordDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.yyy"
            let dateText = dateFormatter.string(from: recordDate)
            dateLabel.text = dateText
        }
        
        recordNameLabel.text = accountingRecord.Name
        balanceLabel.text = "\((accountingRecord.Balance ?? 0.0).formattedCurrency) ₺"
        invoiceDescriptionLabel.text = accountingRecord.InvoiceDescription
        referenceNoLabel.text = accountingRecord.ReferenceNo
        documentNoLabel.text = accountingRecord.DocumentNo
        designationLabel.text = accountingRecord.Designation
        documentTypeLabel.text = accountingRecord.DocumentType
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = accountingRecord.InvoiceDate, let invoiceDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.yyy"
            let invoiceDateText = dateFormatter.string(from: invoiceDate)
            
            invoiceDateLabel.text = invoiceDateText
        }
        
        debtLabel.text = "\((accountingRecord.Debt ?? 0).formattedCurrency) ₺"
        receivableLabel.text = "\((accountingRecord.Receivable ?? 0).formattedCurrency) ₺"
    }
}
