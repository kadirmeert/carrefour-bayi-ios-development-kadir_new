//
//  MenuViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 22.08.2022.
//

import UIKit

protocol MenuViewControllerDelegate {
    func navigateToAccountingPage()
    func navigateToRegionalManagersPage()
    func navigateToOrderManagementPage()
    func navigateToRequestManagementPage()
}

class MenuViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: MenuViewModel!
    var delegate: MenuViewControllerDelegate?
    let reportsViewController: ReportsViewController = ReportsViewController.create()
    let userManagementViewController: UserManagementViewController = UserManagementViewController.create()
    let orderManagementViewController: OrderManagementViewController = OrderManagementViewController.create()
    
    
    // MARK: -Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reportsView: UIView!
    @IBOutlet weak var userManagementView: UIView!
    @IBOutlet weak var orderManagementView: UIView!
    @IBOutlet weak var settingsBaseView: UIView!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        reportsViewController.delegate = self
        userManagementViewController.delegate = self
        orderManagementViewController.delegate = self
        
        reportsView.isHidden = true
        userManagementView.isHidden = true
        orderManagementView.isHidden = true
        settingsBaseView.hideOrShowViewByAppStoreReviewState()
        MenuItemTableViewCell.registerSelf(tableView: tableView)
    }
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        print("settingsButtonClicked")
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        self.viewModel.logout()
    }

}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
        cell.bind(menuItem: viewModel.menuItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemCode = viewModel.menuItems[indexPath.row].menuItemCode
        viewModel.navigateToMenuItem(menuItemCode: menuItemCode)
    }
}

// MARK: -ReportsViewControllerDelegate Methods
extension MenuViewController: ReportsViewControllerDelegate {
    func backButtonClicked() {
        viewModel.isReportMenuUp.toggle()
        
        let height = reportsView.frame.height
        let width = reportsView.frame.width
        
        if !viewModel.isReportMenuUp {
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.reportsViewController.view.frame = CGRect(x: self.reportsView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.reportsView.isHidden = true
                self.reportsViewController.view.removeFromSuperview()
            }
        }
    }
}

// MARK: -UserManagementViewControllerDelegate Methods
extension MenuViewController: UserManagementViewControllerDelegate {
    func navigateToRegionalManagers() {
        delegate?.navigateToRegionalManagersPage()
    }
    
    func backButtonPressed() {
        viewModel.isUserManagementMenuUp.toggle()
        
        let height = userManagementView.frame.height
        let width = userManagementView.frame.width
        
        if !viewModel.isUserManagementMenuUp {
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.userManagementViewController.view.frame = CGRect(x: self.userManagementView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            } completion: { _ in
                self.userManagementView.isHidden = true
                self.userManagementViewController.view.removeFromSuperview()
            }
        }
    }
}

extension MenuViewController: OrderManagementViewControllerDelegate {
    func backButtonPressedOnOrderManagement() {
        viewModel.isOrderManagementMenuUp.toggle()
        
        let height = orderManagementView.frame.height
        let width = orderManagementView.frame.width
        
        if !viewModel.isOrderManagementMenuUp {
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.orderManagementViewController.view.frame = CGRect(x: self.orderManagementView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            } completion: { _ in
                self.orderManagementView.isHidden = true
                self.orderManagementViewController.view.removeFromSuperview()
            }
        }
    }
    
    func navigateToOrderManagementPage() {
        delegate?.navigateToOrderManagementPage()
    }
    
    func navigateToRequestManagementPage() {
        delegate?.navigateToRequestManagementPage()
    }
    
}

// MARK: -MenuViewModelDelegate Methods
extension MenuViewController: MenuViewModelDelegate {
    func navigateToReportsPage() {
        viewModel.isReportMenuUp.toggle()
        
        let height = reportsView.frame.height
        let width = reportsView.frame.width
        
        if viewModel.isReportMenuUp {
            reportsView.isHidden = false
            addSubView(subViewController: reportsViewController, on: reportsView, height: height)
            self.reportsViewController.view.frame = CGRect(x: self.reportsView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            
            UIView.animate(withDuration: 0.3, delay: 0.01, options: .curveLinear) {
                self.reportsViewController.view.frame = CGRect(x: self.reportsView.frame.minX - width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func navigateToUserManagement(){
        viewModel.isUserManagementMenuUp.toggle()
        
        let height = userManagementView.frame.height
        let width = userManagementView.frame.width
        
        if viewModel.isUserManagementMenuUp {
            userManagementView.isHidden = false
            addSubView(subViewController: userManagementViewController, on: userManagementView, height: height)
            self.userManagementViewController.view.frame = CGRect(x: self.userManagementView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            
            UIView.animate(withDuration: 0.3, delay: 0.01, options: .curveLinear) {
                self.userManagementViewController.view.frame = CGRect(x: self.userManagementView.frame.minX - width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func navigateToOrderManagement() {
        viewModel.isOrderManagementMenuUp.toggle()
        let height = orderManagementView.frame.height
        let width = orderManagementView.frame.width
        
        if viewModel.isOrderManagementMenuUp {
            orderManagementView.isHidden = false
            addSubView(subViewController: orderManagementViewController, on: orderManagementView, height: height)
            self.orderManagementViewController.view.frame = CGRect(x: self.orderManagementView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            
            UIView.animate(withDuration: 0.3, delay: 0.01, options: .curveLinear) {
                self.orderManagementViewController.view.frame = CGRect(x: self.userManagementView.frame.minX - width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func navigateToAccountingPage() {
        delegate?.navigateToAccountingPage()
    }
    
    func logoutCompleted() {
        SceneDelegate.shared.rootNavController?.popToRootViewController(animated: true)
    }
}

// MARK: - Creator
extension MenuViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "MenuViewController"
        }
    }
    
    class func create() -> MenuViewController {
        let vc: MenuViewController = MenuViewController.instantiateFromNib()
        let viewModel: MenuViewModel = MenuViewModel()
        
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        viewModel.delegate = vc
        
        return vc
    }
}
