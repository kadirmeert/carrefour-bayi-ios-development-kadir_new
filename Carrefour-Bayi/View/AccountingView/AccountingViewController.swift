//
//  AccountingViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import UIKit

protocol AccountingViewControllerDelegate {
    func backButtonClicked()
    func detailButtonClicked()
}

class AccountingViewController: BaseViewController {
    
    // MARK: -Properties
    var viewModel: AccountingViewModel!
    var delegate: AccountingViewControllerDelegate?
    var error404ViewController = Error404ViewController.create()
    
    // MARK: -Views
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var SAPCodeLabel: UILabel!
    @IBOutlet weak var accountingLabel: UILabel!
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
        CreditLimitTableViewCell.registerSelf(tableView: tableView)
        AccountingDetailTableViewCell.registerSelf(tableView: tableView)
        AccountingTotalTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.backButtonClicked()
    }
}

// MARK: -UITableViewDataSource & UITableViewDelegate Methods
extension AccountingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditLimitTableViewCell") as! CreditLimitTableViewCell
            
            if let creditLimitModel = viewModel.creditLimit {
                cell.bind(creditLimitModel: creditLimitModel)
            }
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingDetailTableViewCell") as! AccountingDetailTableViewCell
            
            if let item = viewModel.storeDashboardDetail {
                cell.bind(item: item)
                cell.delegate = self
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingTotalTableViewCell") as! AccountingTotalTableViewCell
            
            if let item = viewModel.storeDashboardDetail {
                cell.bind(item: item)
            }
            
            return cell
        }
    }
}

//    MARK: - Error404ViewControllerDelegate Methods -
extension AccountingViewController: Error404ViewControllerDelegate {
    func backButtonTappedInError404() {
        delegate?.backButtonClicked()
    }
    
    func presentError404() {
        error404ViewController.delegate = self
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve) {
            self.addSubView(subViewController: self.error404ViewController, on: self.view, height: self.view.frame.height)
        }
    }
}

// MARK: -AccountingDetailTableViewCellDelegate Methods
extension AccountingViewController: AccountingDetailTableViewCellDelegate {
    func detailButtonClicked() {
        delegate?.detailButtonClicked()
    }
}

// MARK: -AccountingViewModelDelegate Methods
extension AccountingViewController: AccountingViewModelDelegate {
    func storeDashboardDetailSuccess(response: GetStoreDashboardDetailResponseDTO) {
        SAPCodeLabel.text = "\(response.SAP ?? 0)"
        accountingLabel.text = response.Cari
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: Date())
        dateLabel.text = dateString
        
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: Date())
    }
    
    func creditLimitSuccess(response: GetCreditLimitResponseDTO) {
        tableView.reloadData()
    }
    
    func pageContentFailed(message: String) {
        if message == "401" {
            presentError404()
        } else {
            self.showErrorAlert(message: message)
        }
    }
}

// MARK: - Creator
extension AccountingViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "AccountingViewController"
        }
    }
    
    class func create(SAPCode: String) -> AccountingViewController {
        let vc: AccountingViewController = AccountingViewController.instantiateFromNib()
        let viewModel: AccountingViewModel = AccountingViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        viewModel.SAPCode = SAPCode
        
        return vc
    }
}
