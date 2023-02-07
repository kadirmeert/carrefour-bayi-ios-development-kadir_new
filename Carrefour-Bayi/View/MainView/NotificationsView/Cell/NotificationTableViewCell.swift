//
//  NotificationTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 31.08.2022.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notificationView: BaseView!
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    var dateFormatterForUser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy | HH:mm"
        return formatter
    }()
    
    
    // MARK: -UI Methods
    func bind(notificationModel: Notifications) {
        let endPointDate = notificationModel.InsertDate?.components(separatedBy: ".")
        let removedZDate = endPointDate![0]
        if let recordDate = dateFormatter.date(from: removedZDate) {
            let dateText = dateFormatterForUser.string(from: recordDate)
            dateLabel.text = dateText
        }
        
        descriptionLabel.text = notificationModel.Body ?? "No Description"
        
        if let isRead = notificationModel.IsRead {
            descriptionLabel.textColor = setTextColor(isRead: isRead)
            dateLabel.textColor = setTextColor(isRead: isRead)
            notificationView.isHidden = isRead ? true : false
        }
    }
    
    private func setTextColor(isRead: Bool) -> UIColor {
        return isRead ? .primaryDarkGray.withAlphaComponent(0.5) : .primaryDarkGray.withAlphaComponent(1)
    }
}
