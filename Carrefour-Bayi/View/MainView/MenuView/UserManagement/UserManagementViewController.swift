//
//  UserManagementViewController.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 13.11.2022.
//

import UIKit

protocol UserManagementViewControllerDelegate {
    func backButtonPressed()
    func navigateToRegionalManagers()
}

class UserManagementViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: UserManagementViewModel!
    var delegate: UserManagementViewControllerDelegate?

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
    
    @IBAction func backButtonClicked(_ sender: Any) {
        delegate?.backButtonPressed()
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension UserManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userManagementItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportItemTableViewCell") as! ReportItemTableViewCell
        
        cell.bind(menuItemTitle: viewModel.userManagementItems[indexPath.row].userManagementItemTitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemCode = viewModel.userManagementItems[indexPath.row].userManagementItemCode
        
        viewModel.navigateToUserManagementMenuItem(menuItemCode: menuItemCode)
    }
}

// MARK: -ReportsViewModelDelegate Methods
extension UserManagementViewController: UserManagementViewModelDelegate {
    func navigateToRegionalManagers() {
        delegate?.navigateToRegionalManagers()
    }
}

// MARK: - Creator
extension UserManagementViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "UserManagementViewController"
        }
    }
    
    class func create() -> UserManagementViewController {
        let vc: UserManagementViewController = UserManagementViewController.instantiateFromNib()
        let viewModel: UserManagementViewModel = UserManagementViewModel()
        
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        viewModel.delegate = vc
        
        return vc
    }
}
