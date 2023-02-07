//
//  AccountingDetailViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import UIKit
import LGButton

class AccountingSection {
    var record: AccountingRecord?
    var isHidden: Bool = true
    
    init(isHidden: Bool = true, record: AccountingRecord?) {
        self.isHidden = isHidden
        self.record = record
    }
}

class AccountingDetailViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: AccountingDetailViewModel!
    var error404ViewController = Error404ViewController.create()
    private var sections = [AccountingSection]()
    private let datePicker: UIDatePicker = UIDatePicker()
    
    // MARK: -Views
    @IBOutlet weak var firstDateTextField: UITextField!
    @IBOutlet weak var lastDateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "tr_TR")
        datePicker.date = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        firstDateTextField.inputView = datePicker
        lastDateTextField.inputView = datePicker
        
        let lastWeekDate = NSCalendar.current.date(byAdding: .weekOfYear, value: -1, to: NSDate() as Date)
        firstDateTextField.text = viewModel.fieldsDateFormatter.string(from: lastWeekDate ?? Date())
        lastDateTextField.text = viewModel.fieldsDateFormatter.string(from: Date())
        
        firstDateTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.firstDateSelected(_:)))
        lastDateTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.lastDateSelected(_:)))
        
        AccountingInfoTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func firstDateSelected(_ sender: Any) {
        firstDateTextField.text = viewModel.fieldsDateFormatter.string(from: datePicker.date)
        
        viewModel.startDate = viewModel.endpointDateFormatter.string(from: datePicker.date)
    }
    
    @objc func lastDateSelected(_ sender: Any) {
        lastDateTextField.text = viewModel.fieldsDateFormatter.string(from: datePicker.date)
        
        viewModel.endDate = viewModel.endpointDateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func filterButtonClicked(_ sender: LGButton) {
        viewModel.getAccountingReport()
    }
    
    @IBAction func excelButtonClicked(_ sender: LGButton) {
        viewModel.getAccountingReportExcel()
    }
    
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension AccountingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingInfoTableViewCell") as! AccountingInfoTableViewCell
        
        if let record = sections[indexPath.row].record {
            cell.bind(accountingRecord: record, isHidden: sections[indexPath.row].isHidden)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.row].isHidden.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}


extension AccountingDetailViewController: Error404ViewControllerDelegate {
    func backButtonTappedInError404() {
        self.dismiss(animated: true)
    }
    
    func presentError404() {
        error404ViewController.delegate = self
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve) {
            self.addSubView(subViewController: self.error404ViewController, on: self.view, height: self.view.frame.height)
        }
    }


}

// MARK: -AccountingDetailViewModelDelegate Methods
extension AccountingDetailViewController: AccountingDetailViewModelDelegate {
    func pageContentSuccess() {
        if let accountingReports = viewModel.accountingReport?.Records {
            
            sections = accountingReports.map({ accountingRecord in
                return AccountingSection(record: accountingRecord)
            })
            
            tableView.reloadData()
        }
    }
    
    func pageContentFailed(message: String) {
        if message == "401" {
            presentError404()
        } else {
            showErrorAlert(message: message)
        }
    }
}

// MARK: - Creator
extension AccountingDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "AccountingDetailViewController"
        }
    }
    
    class func create(companyCode: String) -> AccountingDetailViewController {
        let vc: AccountingDetailViewController = AccountingDetailViewController.instantiateFromNib()
        let viewModel: AccountingDetailViewModel = AccountingDetailViewModel()
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .fullScreen
        viewModel.delegate = vc
        viewModel.companyCode = companyCode
        
        return vc
    }
}
