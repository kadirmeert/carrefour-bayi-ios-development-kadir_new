//
//  OrderManagementViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 22.11.2022.
//

import UIKit

protocol OrderManagementViewControllerDelegate {
    func backButtonPressedOnOrderManagement()
    func navigateToOrderManagementPage()
    func navigateToRequestManagementPage()
}

class OrderManagementViewController: BaseViewController {

    //    MARK: - Properties -
    var viewModel: OrderManagementViewModel!
    var delegate: OrderManagementViewControllerDelegate?
    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }


    private func initUI() {
        ReportItemTableViewCell.registerSelf(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        delegate?.backButtonPressedOnOrderManagement()
    }
    
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension OrderManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderManagementItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportItemTableViewCell") as! ReportItemTableViewCell
        
        cell.bind(menuItemTitle: viewModel.orderManagementItems[indexPath.row].orderManagementItemTitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemCode = viewModel.orderManagementItems[indexPath.row].orderManagementItemCode
        viewModel.navigateToOrderManagementMenuItem(menuItemCode: menuItemCode)
    }
}


// MARK: -ReportsViewModelDelegate Methods
extension OrderManagementViewController: OrderManagementViewModelDelegate {
    func navigateToOrderManagement() {
        delegate?.navigateToOrderManagementPage()
    }
    
    func navigateToRequestManagement() {
        delegate?.navigateToRequestManagementPage()
    }
}

// MARK: - Creator
extension OrderManagementViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "OrderManagementViewController"
        }
    }
    
    class func create() -> OrderManagementViewController {
        let vc: OrderManagementViewController = OrderManagementViewController.instantiateFromNib()
        let viewModel: OrderManagementViewModel = OrderManagementViewModel()
        
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        viewModel.delegate = vc
        
        return vc
    }
}
