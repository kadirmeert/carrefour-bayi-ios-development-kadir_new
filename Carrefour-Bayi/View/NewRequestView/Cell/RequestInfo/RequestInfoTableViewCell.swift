//
//  RequestInfoTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 15.12.2022.
//

import UIKit
import LGButton

struct RequestInfoTableViewCellModel {
    var requestNo: String
    var currentCompanyAndStore: CurrentCompanyAndStore
    var isHiddenSaveButton: Bool = false
    var date: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }()
}


protocol RequestInfoTableViewCellDelegate {
    func saveRequestInfoClickedInRequestInfoCell(requestNo: String, requestDateForService: String,
                                                 requestDateForUser: String)
}

class RequestInfoTableViewCell: UITableViewCell {
    
    var delegate: RequestInfoTableViewCellDelegate?
    private let datePicker: UIDatePicker = UIDatePicker()
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    var requestInfoTableViewCellModel: RequestInfoTableViewCellModel?
    
    //    MARK: - views
    @IBOutlet weak var requestNoLabel: UILabel!
    @IBOutlet weak var requestDateTextField: UITextField!
    @IBOutlet weak var saveButton: LGButton!
    
    
    var endpointDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var frontendDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    
    func bind(requestNo: String, requestDate: String?) {
        setupDatePicker()
        requestNoLabel.text = requestNo
        
        if let requestDate = requestDate {
            requestDateTextField.text = requestDate
            saveButton.isHidden = true
            requestDateTextField.isUserInteractionEnabled = false
        } else {
            requestDateTextField.text = frontendDateFormatter.string(from: datePicker.date)
            requestDateTextField.keyboardToolbar.doneBarButton.setTarget(self,
                                                                         action: #selector(self.dateSelected(_:)))
        }
        
    }
    
    @IBAction func changeDateButtonClicked(_ sender: Any) {
        requestDateTextField.becomeFirstResponder()
    }
    
    
    @IBAction func saveRequestInfoClicked(_ sender: Any) {
        let endpointDate = endpointDateFormatter.string(from: datePicker.date)
        let frontendDate = frontendDateFormatter.string(from: datePicker.date)
        if let requestNo = requestNoLabel.text {
            delegate?.saveRequestInfoClickedInRequestInfoCell(requestNo: requestNo, requestDateForService: endpointDate, requestDateForUser: frontendDate)
        }
    }
    
    
    private func setupDatePicker() {
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "tr_TR")
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        requestDateTextField.inputView = datePicker
    }
    
    @objc
    func datePickerChanged() {
        requestDateTextField.text = frontendDateFormatter.string(from: datePicker.date)
    }
    
    @objc
    func dateSelected(_ sender: Any) {
        requestDateTextField.text = frontendDateFormatter.string(from: datePicker.date)
    }
}
