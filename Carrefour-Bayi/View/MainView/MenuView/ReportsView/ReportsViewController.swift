//
//  ReportsViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 15.09.2022.
//

import UIKit

protocol ReportsViewControllerDelegate {
    func backButtonClicked()
}

class ReportsViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: ReportsViewModel!
    var delegate: ReportsViewControllerDelegate?
    
    // MARK: -Views
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
        ReportItemTableViewCell.registerSelf(tableView: tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.backButtonClicked()
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension ReportsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportItemTableViewCell") as! ReportItemTableViewCell
        
        cell.bind(menuItemTitle: viewModel.reportItems[indexPath.row].reportTitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemCode = viewModel.reportItems[indexPath.row].reportItemCode
        
        viewModel.navigateToReportMenuItem(menuItemCode: menuItemCode)
    }
}

// MARK: -ReportsViewModelDelegate Methods
extension ReportsViewController: ReportsViewModelDelegate {
    
}

// MARK: - Creator
extension ReportsViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "ReportsViewController"
        }
    }
    
    class func create() -> ReportsViewController {
        let vc: ReportsViewController = ReportsViewController.instantiateFromNib()
        let viewModel: ReportsViewModel = ReportsViewModel()
        
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        viewModel.delegate = vc
        
        return vc
    }
}
