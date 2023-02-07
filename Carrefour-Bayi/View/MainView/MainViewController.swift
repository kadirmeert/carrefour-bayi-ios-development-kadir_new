//
//  MainViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.08.2022.
//

import UIKit
import SafariServices

class MainViewController: BaseViewController {

    // MARK: -Properties
    var viewModel: MainViewModel!
    
    var regionalDirectorateViewController: RegionalDirectorateViewController?
    var accountingViewController: AccountingViewController?
    var allRequestViewController: AllRequestViewController?
    var allOrderViewController: AllOrderViewController?
    var newRequestViewController: NewRequestViewController?
    var requestDetailViewController: RequestDetailViewController?
    var announcementDetailViewController: AnnouncementDetailViewController?
    var storesViewController: StoresViewController?
    var notificationViewController = NotificationsViewController.create()
    var menuViewController = MenuViewController.create()
    var requestsViewController: RequestsViewController?
    var orderViewController: OrderViewController?
    var paymentTabViewController: PaymentViewController?
    
    // MARK: -Views
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var basketContainerView: UIView!
    //    @IBOutlet weak var basketCountLabel: UILabel!
    @IBOutlet weak var basketButton: BaseButton!
    @IBOutlet weak var notificationContainerView: UIView!
    //    @IBOutlet weak var notificationIcon: BaseView!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationButton: BaseButton!
    @IBOutlet weak var storeContainerView: UIView!
    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var storeIconClose: UIImageView!
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    
    private var isNotificationsViewUp: Bool = false
    private var isStoresViewUp: Bool = false
    
    private var isDashboardUp: Bool = false
    @IBOutlet weak var dashboardTabContainerView: BaseView!
    @IBOutlet weak var dashboardTabImageView: UIImageView!
    @IBOutlet weak var dashboardTabCenterYConstraint: NSLayoutConstraint!
    
    private var isPaymentTabUp: Bool = false
    @IBOutlet weak var paymentTabContainerView: BaseView!
    @IBOutlet weak var paymentTabImageView: UIImageView!
    @IBOutlet weak var paymentTabCenterYConstraint: NSLayoutConstraint!
    
    private var isMenuUp: Bool = false
    @IBOutlet weak var menuButton: BaseButton!
    
    private var isRequestsViewUp: Bool = false
    @IBOutlet weak var requestsTabContainerView: BaseView!
    @IBOutlet weak var requestsTabImageView: UIImageView!
    @IBOutlet weak var requestsTabCenterYConstraint: NSLayoutConstraint!
    
    private var isOrderViewUp: Bool = false
    @IBOutlet weak var orderTabContainerView: BaseView!
    @IBOutlet weak var orderTabImageView: UIImageView!
    @IBOutlet weak var orderTabCenterYConstraint: NSLayoutConstraint!
    
    private var isAccountingViewUp: Bool = false
    private var isAllRequestViewUp: Bool = false
    private var isNewRequestViewUp: Bool = false
    private var isAllOrderViewUp: Bool = false
    private var isRequestDetailViewUp: Bool = false
    private var isAnnouncementViewUp: Bool = false
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        if let companyAndStore = viewModel.companyAndStoreModel, let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            storeTitleLabel.text = companyAndStore.CompanyName
            storeDescriptionLabel.text = companyAndStore.StoreName
            
            storesViewController = StoresViewController.create(companyAndStoreModel: companyAndStore)
            storesViewController?.delegate = self
            
            orderViewController = OrderViewController.create(currentCompanyAndStore: currentCompanyAndStore)
            paymentTabViewController = PaymentViewController.create(currentCompanyAndStore: currentCompanyAndStore)
            paymentTabViewController?.delegate = self
        }
        
        menuViewController.delegate = self
        
        
        DashboardTableViewCell.registerSelf(tableView: homeTableView)
        CreditLimitTableViewCell.registerSelf(tableView: homeTableView)
        ReportsTableViewCell.registerSelf(tableView: homeTableView)
        DashboardRequestsTableViewCell.registerSelf(tableView: homeTableView)
        AccountingAndCatalogTableViewCell.registerSelf(tableView: homeTableView)
        GiftCardTableViewCell.registerSelf(tableView: homeTableView)
        CovidPrecautionsTableViewCell.registerSelf(tableView: homeTableView)
        OrderSuggestionTableViewCell.registerSelf(tableView: homeTableView)
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        orderTabContainerView.cornerRadius = orderTabContainerView.frame.height / 2
        requestsTabContainerView.cornerRadius = requestsTabContainerView.frame.height / 2
        homeTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 90,right: 0)
    }
    
    //    MARK: - TAB CLICKS -
    @IBAction func dashboardTabClicked(_ sender: UIButton) {
        switch viewModel.tabState {
            case .menuTabUp:
                tabMenuClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabDashboardClicked()
                }
            case .orderTabUp:
                tabOrderClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabDashboardClicked()
                }
            case .requestsTabUp:
                tabRequestsClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabDashboardClicked()
                }
            case .accountingTabUp:
                paymentTabClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabDashboardClicked()
                }
            case .none, .dashboardTabUp:
                tabDashboardClicked()
        }
    }
    
    @IBAction func paymentTabClicked(_ sender: UIButton) {
        switch viewModel.tabState {
            case .dashboardTabUp:
                tabDashboardClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.paymentTabClicked()
                }
            case .requestsTabUp:
                tabRequestsClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.paymentTabClicked()
                }
            case .orderTabUp:
                tabOrderClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.paymentTabClicked()
                }
            case .menuTabUp:
                tabMenuClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.paymentTabClicked()
                }
            case .none, .accountingTabUp:
                paymentTabClicked()
        }
    }
    
    @IBAction func requestsTabClicked(_ sender: UIButton) {
        switch viewModel.tabState {
            case .orderTabUp:
                tabOrderClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabRequestsClicked()
                }
            case .menuTabUp:
                tabMenuClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabRequestsClicked()
                }
            case .dashboardTabUp:
                tabDashboardClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabRequestsClicked()
                }
            case .accountingTabUp:
                paymentTabClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabRequestsClicked()
                }
                
            case .none, .requestsTabUp:
                tabRequestsClicked()
        }
    }
    
    @IBAction func orderTabClicked(_ sender: UIButton) {
        switch viewModel.tabState {
            case .requestsTabUp:
                tabRequestsClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabOrderClicked()
                }
            case .menuTabUp:
                tabMenuClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabOrderClicked()
                }
            case .dashboardTabUp:
                tabDashboardClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabOrderClicked()
                }
            case .accountingTabUp:
                paymentTabClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabOrderClicked()
                }
            case .none, .orderTabUp:
                tabOrderClicked()
        }
    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        switch viewModel.tabState {
            case .requestsTabUp:
                tabRequestsClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabMenuClicked()
                }
            case .orderTabUp:
                tabOrderClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabMenuClicked()
                }
            case .dashboardTabUp:
                tabDashboardClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabMenuClicked()
                }
            case .accountingTabUp:
                paymentTabClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {[weak self] in
                    self?.tabMenuClicked()
                }
            case .none, .menuTabUp:
                tabMenuClicked()
        }
    }
    
    
    @IBAction func basketButtonClicked(_ sender: UIButton) {
        print("basketButtonClicked")
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        isNotificationsViewUp.toggle()
        
        if isNotificationsViewUp {
            navigationView.isHidden = false
            
            addSubView(subViewController: notificationViewController, on: navigationView, height: navigationView.frame.height)
            
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                self.navigationView.alpha = 1
            }
            
            UIView.transition(with: notificationImageView, duration: 0.5, options: .transitionCrossDissolve) {
                var image = UIImage(systemName: "multiply")
                image = image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 27, weight: .semibold))
                self.notificationImageView.tintColor = .primaryRed
                self.notificationImageView.image = image
                //                self.notificationImageView.image = UIImage(named: "icon_close_red")
            }
            //            UIView.transition(with: notificationIcon, duration: 0.5, options: .transitionCrossDissolve) {
            //                self.notificationIcon.isHidden = true
            //            }
        }
        else {
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                self.navigationView.alpha = 0
            } completion: { _ in
                self.navigationView.isHidden = true
                self.notificationViewController.view.removeFromSuperview()
            }
            
            UIView.transition(with: notificationImageView, duration: 0.5, options: .transitionCrossDissolve) {
                self.notificationImageView.image = UIImage(named: "icon_notification")
            }
            //            UIView.transition(with: notificationIcon, duration: 0.5, options: .transitionCrossDissolve) {
            //                self.notificationIcon.isHidden = false
            //            }
        }
    }
    
    @IBAction func storeButtonClicked(_ sender: UIButton) {
        guard let storesViewController = storesViewController else {
            return
        }
        
        isStoresViewUp.toggle()
        
        if isStoresViewUp {
            navigationView.isHidden = false
            
            addSubView(subViewController: storesViewController, on: navigationView, height: navigationView.frame.height)
            
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                
                self.navigationView.alpha = 1
            }
            
            UIView.transition(with: storeIcon, duration: 0.5, options: .transitionCrossDissolve) {
                self.storeIcon.isHidden = true
            }
            
            UIView.transition(with: storeIconClose, duration: 0.5, options: .transitionCrossDissolve) {
                self.storeIconClose.isHidden = false
            }
        }
        else {
            UIView.transition(with: storeIcon, duration: 0.5, options: .transitionCrossDissolve) {
                self.storeIcon.isHidden = false
            }
            
            UIView.transition(with: storeIconClose, duration: 0.5, options: .transitionCrossDissolve) {
                self.storeIconClose.isHidden = true
            }
            
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                self.navigationView.alpha = 0
            } completion: { _ in
                self.navigationView.isHidden = true
                self.storesViewController?.view.removeFromSuperview()
            }
        }
    }
    
    //    MARK: - TAB FUNCS -
    func tabMenuClicked() {
        isMenuUp.toggle()
        let height = homeView.frame.height
        let width = homeView.frame.width
        
        if isMenuUp {
//            homeView.isHidden = false
            addSubView(subViewController: menuViewController, on: homeView, height: height)
            self.menuViewController.view.frame = CGRect(x: self.homeView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
            
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.menuButton.tintColor = .white
                let image = UIImage(systemName: "multiply")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.black))
                self.menuButton.setImage(image, for: .normal)
                
                self.menuViewController.view.frame = CGRect(x: self.homeView.frame.minX - width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.viewModel.tabState = .menuTabUp
            }
        }
        else {
            
            UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveLinear) {
                
                
                self.menuButton.setImage(UIImage(named: "icon_menu"), for: .normal)
                
                self.menuViewController.view.frame = CGRect(x: self.homeView.frame.minX + width, y: self.view.frame.minY, width: width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
//                self.homeView.isHidden = true
                self.menuViewController.view.removeFromSuperview()
                self.viewModel.tabState = .none
            }
        }
    }
    
    func tabRequestsClicked() {
        isRequestsViewUp.toggle()
        let height = homeView.frame.height
        let width = homeView.frame.width
        
        if isRequestsViewUp {
            if let purchaseRequestResponse = viewModel.purchaseRequestResponseModel {
                requestsViewController = RequestsViewController.create(purchaseRequestResponseModel: purchaseRequestResponse, currentCompanyAndStore: viewModel.currentCompanyAndStore)
                addSubView(subViewController: requestsViewController!, on: homeView, height: height)
            }
            requestsViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY, width: width, height: height)
            
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.requestsTabContainerView.cornerRadius = self.requestsTabContainerView.frame.height / 2
                self.requestsTabContainerView.backgroundColor = .primaryDarkBlue
                self.requestsTabCenterYConstraint.constant = -30
                self.requestsTabImageView.image = UIImage(named: "icon_tab_requests_selected")
                
                self.requestsViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY - height, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.viewModel.tabState = .requestsTabUp
            }
        }
        else {
            UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveLinear) {
                self.requestsTabContainerView.cornerRadius = self.requestsTabContainerView.frame.height / 2
                self.requestsTabContainerView.backgroundColor = .clear
                self.requestsTabCenterYConstraint.constant = 0
                self.requestsTabImageView.image = UIImage(named: "icon_tab_requests")
                
                self.requestsViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.requestsViewController!.view.removeFromSuperview()
                self.viewModel.tabState = .none
            }
        }
    }
    
    func tabOrderClicked() {
        isOrderViewUp.toggle()
        let height = homeView.frame.height
        let width = homeView.frame.width
        
        if isOrderViewUp {
            
            if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
                orderViewController = OrderViewController.create(currentCompanyAndStore: currentCompanyAndStore)
                addSubView(subViewController: orderViewController!, on: homeView, height: height)
            }
            
            orderViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY, width: width, height: height)
            
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) { [self] in
                self.orderTabContainerView.cornerRadius = self.orderTabContainerView.frame.height / 2
                self.orderTabContainerView.backgroundColor = .primaryDarkBlue
                self.orderTabCenterYConstraint.constant = -30
                self.orderTabImageView.image = UIImage(named: "icon_tab_order_selected")
                
                orderViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY - height, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.viewModel.tabState = .orderTabUp
            }
        }
        else {
            UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveLinear) { [self] in
                self.orderTabContainerView.cornerRadius = self.orderTabContainerView.frame.height / 2
                self.orderTabContainerView.backgroundColor = .clear
                self.orderTabCenterYConstraint.constant = 0
                self.orderTabImageView.image = UIImage(named: "icon_tab_order")
                
                orderViewController!.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { [self] _ in
                orderViewController!.view.removeFromSuperview()
                self.viewModel.tabState = .none
            }
        }
    }
    
    func paymentTabClicked() {
        isPaymentTabUp.toggle()
        let height = homeView.frame.height
        
        if isPaymentTabUp {
            if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
                paymentTabViewController = PaymentViewController.create(currentCompanyAndStore: currentCompanyAndStore)
            }
            guard let paymentTabViewController else { return }
                homeView.isHidden = false
                addSubView(subViewController: paymentTabViewController, on: homeView, height: height)
                
                UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                    self.paymentTabContainerView.cornerRadius = self.paymentTabContainerView.frame.height / 2
                    self.paymentTabContainerView.backgroundColor = .primaryDarkBlue
                    self.paymentTabCenterYConstraint.constant = -30
                    let tintedImage = UIImage(named: "icon_tab_accounting")
                    self.paymentTabImageView.image = tintedImage?.withBackground(color: .primaryDarkBlue, fill: .white)
                    
                    self.paymentTabViewController?.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY - height, width: self.view.frame.width, height: height * 0.5)
                    
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.viewModel.tabState = .accountingTabUp
                }
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveLinear) {
                self.paymentTabContainerView.cornerRadius = self.paymentTabContainerView.frame.height / 2
                self.paymentTabContainerView.backgroundColor = .clear
                self.paymentTabCenterYConstraint.constant = 0
                self.paymentTabImageView.image = UIImage(named: "icon_tab_accounting")
                self.paymentTabViewController?.view.frame = CGRect(x: self.homeView.frame.minX, y: self.homeView.frame.maxY, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.paymentTabViewController?.view.removeFromSuperview()
                self.viewModel.tabState = .none
            }
        }
    }
    
    func tabDashboardClicked() {
        isDashboardUp.toggle()
//        let height = tabBarView.frame.height
//        let width = tabBarView.frame.width
        
        if isDashboardUp {
//            navigationView.isHidden = false
//            tabBarView.isHidden = false
//            addSubView(subViewController: accountingTabViewController, on: navigationView, height: navigationView.frame.height)
//            accountingTabViewController.view.frame = CGRect(x: self.navigationView.frame.minX, y: self.navigationView.frame.maxY, width: width, height: height)
            
            UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveLinear) {
                self.dashboardTabContainerView.cornerRadius = self.dashboardTabContainerView.frame.height / 2
                
                self.dashboardTabContainerView.backgroundColor = .primaryDarkBlue
                self.dashboardTabCenterYConstraint.constant = -30
                let tintedImage = UIImage(named: "icon_Home")
                self.dashboardTabImageView.image = tintedImage?.withBackground(color: .primaryDarkBlue, fill: .white)
//                self.accountingTabViewController.view.frame = CGRect(x: self.navigationView.frame.minX, y: self.navigationView.frame.maxY - height, width: self.view.frame.width, height: height)

                self.view.layoutIfNeeded()
            } completion: { _ in
                self.viewModel.tabState = .dashboardTabUp
            }
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveLinear) {
                self.dashboardTabContainerView.cornerRadius = self.dashboardTabContainerView.frame.height / 2
                self.dashboardTabContainerView.backgroundColor = .clear
                self.dashboardTabCenterYConstraint.constant = 0
                self.dashboardTabImageView.image = UIImage(named: "icon_Home")
//                self.accountingTabViewController.view.frame = CGRect(x: self.tabBarView.frame.minX, y: self.tabBarView.frame.maxY, width: self.view.frame.width, height: height)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
//                self.navigationView.isHidden = true
//                self.tabBarView.isHidden = true
//                self.accountingTabViewController.view.removeFromSuperview()
                self.viewModel.tabState = .none
            }
        }
    }
    
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as! DashboardTableViewCell
            if let advertisementData = viewModel.advertisementModel {
                if !advertisementData.isEmpty {
                    cell.delegate = self
                    cell.bind(dashboardItems: advertisementData)
                }
            }
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditLimitTableViewCell") as! CreditLimitTableViewCell
            

            if let creditLimitModel = viewModel.creditLimitModel {
                cell.bind(creditLimitModel: creditLimitModel)
                cell.delegate = self
            }
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSuggestionTableViewCell") as! OrderSuggestionTableViewCell
            cell.selectionStyle = .none
            cell.bind()
            cell.delegate = self
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardRequestsTableViewCell") as! DashboardRequestsTableViewCell
            cell.selectionStyle = .none
            if let requestsModel = viewModel.purchaseRequestResponseModel {
                cell.bind(requestsModel: requestsModel)
                cell.delegate = self
            } else {
                cell.bind(requestsModel: GetAllPurchaseResponseDTO(info: nil, Data: nil))
                cell.delegate = self
            }
            
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingAndCatalogTableViewCell") as! AccountingAndCatalogTableViewCell
            
            cell.bind()
            cell.delegate = self
            
            return cell
        }
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardTableViewCell") as! GiftCardTableViewCell
            
            cell.bind()
            cell.delegate = self
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CovidPrecautionsTableViewCell") as! CovidPrecautionsTableViewCell
            
            cell.bind()
            cell.delegate = self
            
            return cell
        }
    }
}

//    MARK: - Payment ViewControllerDelegate Methods
extension MainViewController: PaymentViewControllerDelegate {
    func backButtonClickedInPayment() {
        paymentTabClicked()
    }
}


// MARK: - DashboardItemDelegate -
extension MainViewController: DashboardItemDelegate {
    func dashboardAnnouncementClicked(index: Int) {
        if let advertisementData = viewModel.advertisementModel {
            if !advertisementData.isEmpty {
                announcementDetailViewController = AnnouncementDetailViewController.create(advertisementData: advertisementData[index])
                announcementDetailViewController?.delegate = self
                navigationView.isHidden = false
                guard let announcementDetailViewController = announcementDetailViewController else { return }
                addSubView(subViewController: announcementDetailViewController, on: navigationView, height: navigationView.frame.height)
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 1
                }
            }
        }
    }
}

// MARK: - AnnouncementDetailViewControllerDelegate -
extension MainViewController: AnnouncementDetailViewControllerDelegate {
    func backButtonTappedInAnnouncement() {
        UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
            self.navigationView.alpha = 0
        } completion: { _ in
            self.navigationView.isHidden = true
            self.announcementDetailViewController?.view.removeFromSuperview()
        }
    }
}

// MARK: - OrderSuggestionTableViewCellDelegate -
extension MainViewController: OrderSuggestionTableViewCellDelegate {
    func orderSuggestionClicked() {
    }
}

// MARK: -CreditLimitTableViewCellDelegate Methods -
extension MainViewController: CreditLimitTableViewCellDelegate {
    func navigateToCreditDetail() {
        accountingButtonClicked()
    }
}

// MARK: -CovidPrecautionsTableViewCellDelegate Methods -
extension MainViewController: CovidPrecautionsTableViewCellDelegate {
    func covidPrecautionsClicked() {
        let vc: GeneralPopupViewController = GeneralPopupViewController.create()
        self.present(vc, animated: true)
    }
}

// MARK: -GiftCardTableViewCellDelegate Methods -
extension MainViewController: GiftCardTableViewCellDelegate {
    func giftCardButtonClicked() {
        if let url = URL(string: viewModel.giftCardUrl) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

// MARK: -AccountingViewControllerDelegate Methods-
extension MainViewController: AccountingViewControllerDelegate {
    func backButtonClicked() {
        accountingButtonClicked()
    }
    
    func detailButtonClicked() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            let vc: AccountingDetailViewController = AccountingDetailViewController.create(companyCode: String(currentCompanyAndStore.companyCode))
            
            self.present(vc, animated: true)
        }
    }
}

// MARK: -RegionalManagerViewControllerDelegate Methods-
extension MainViewController: RegionalDirectorateViewControllerDelegate{
    func regionalDirectoriesBackButtonTapped() {
        UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
            self.navigationView.alpha = 0
        } completion: { _ in
            self.navigationView.isHidden = true
            self.regionalDirectorateViewController?.view.removeFromSuperview()
        }
    }
}


//    MARK: - AllRequestViewControllerDelegate Methods
extension MainViewController: AllRequestViewControllerDelegate {
    func backButtonTapped() {
        allRequestButtonTapped()
    }
}


//    MARK: - AllOrderViewControllerDelegate Methods
extension MainViewController: AllOrderViewControllerDelegate {
    func backButtonTappedInAllOrderViewController() {
        navigateToOrderManagementPage()
    }
}


//    MARK: - NewRequestViewControllerDelegate Methods
extension MainViewController: NewRequestViewControllerDelegate {
    func backButtonTappedInNewRequest() {
        addRequestButtonTapped()
    }
}

//    MARK: - DashboardRequestTableViewCellDelegate -
extension MainViewController: DashboardRequestTableViewCellDelegate {
    func allRequestButtonTapped() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            isAllRequestViewUp.toggle()
            if isAllRequestViewUp {
                allRequestViewController = AllRequestViewController.create(currentCompanyAndStore: currentCompanyAndStore)
                allRequestViewController?.delegate = self
                
                guard let allRequestViewController = allRequestViewController else {
                    return
                }
                
                navigationView.isHidden = false
                
                addSubView(subViewController: allRequestViewController, on: navigationView, height: navigationView.frame.height)
                
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 1
                }
            }
            else {
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 0
                } completion: { _ in
                    self.navigationView.isHidden = true
                    self.allRequestViewController?.view.removeFromSuperview()
                }
            }
        }
    }
    
    func addRequestButtonTapped() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            isNewRequestViewUp.toggle()
            if isNewRequestViewUp {
                newRequestViewController = NewRequestViewController.create(currentCompanyAndStore: currentCompanyAndStore)
                newRequestViewController?.delegate = self
                guard let newRequestViewController = newRequestViewController else { return }
                navigationView.isHidden = false
                addSubView(subViewController: newRequestViewController, on: navigationView, height: navigationView.frame.height)
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 1
                }
            } else {
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 0
                } completion: { _ in
                    self.navigationView.isHidden = true
                    self.newRequestViewController?.view.removeFromSuperview()
                }
            }
        }
    }
    
    func requestDetailTapped(requestData: PurchaseRequestData?) {
        isRequestDetailViewUp.toggle()
        if isRequestDetailViewUp && requestData != nil {
            requestDetailViewController = RequestDetailViewController.create(requestData: requestData!)
            requestDetailViewController?.delegate = self
            
            guard let requestsViewController = requestDetailViewController else {
                return
            }
            navigationView.isHidden = false
            
            addSubView(subViewController: requestsViewController, on: navigationView, height: navigationView.frame.height)
            
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                self.navigationView.alpha = 1
            }
        } else {
            UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                self.navigationView.alpha = 0
            } completion: { _ in
                self.navigationView.isHidden = true
                self.requestDetailViewController?.view.removeFromSuperview()
            }
        }
    }
}

//    MARK: - RequestDetailViewControllerDelegate Methods -
extension MainViewController: RequestDetailViewControllerDelegate {
    func deleteButtonClicked(id: Int) {
         
    }
    
    func backButtonTappedInRequestDetailDet() {
        self.requestDetailTapped(requestData: nil)
    }
}

// MARK: -AccountingAndCatalogTableViewCellDelegate Methods-
extension MainViewController: AccountingAndCatalogTableViewCellDelegate {
    func accountingButtonClicked() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            isAccountingViewUp.toggle()
            if isAccountingViewUp {
                accountingViewController = AccountingViewController.create(SAPCode: String(currentCompanyAndStore.sapCode))
                accountingViewController?.delegate = self
                
                guard let accountingViewController = accountingViewController else {
                    return
                }
                
                navigationView.isHidden = false
                
                addSubView(subViewController: accountingViewController, on: navigationView, height: navigationView.frame.height)
                
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 1
                }
            }
            else {
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 0
                } completion: { _ in
                    self.navigationView.isHidden = true
                    self.accountingViewController?.view.removeFromSuperview()
                }
            }
        }
    }
    
    func catalogButtonClicked() {
        if let url = URL(string: viewModel.catalogUrl) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

// MARK: -StoresViewControllerDelegate Methods-
extension MainViewController: StoresViewControllerDelegate {
    func selectedStoreChanged(currentCompanyAndStore: CurrentCompanyAndStore, companyName: String, storeName: String) {
        viewModel.currentCompanyAndStore = currentCompanyAndStore
        storeTitleLabel.text = companyName
        storeDescriptionLabel.text = storeName
        viewModel.getCreditLimit()
        viewModel.getPurchaseRequest()
    }
}

// MARK: -MenuViewControllerDelegate Methods
extension MainViewController: MenuViewControllerDelegate {
    func navigateToRequestManagementPage() {
        self.allRequestButtonTapped()
    }
    
    func navigateToOrderManagementPage() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            isAllOrderViewUp.toggle()
            if isAllOrderViewUp {
                allOrderViewController = AllOrderViewController.create(currentCompanyAndStore: currentCompanyAndStore)
                allOrderViewController?.delegate = self
                guard let allOrderViewController = allOrderViewController else { return }
                
                navigationView.isHidden = false
                addSubView(subViewController: allOrderViewController, on: navigationView, height: navigationView.frame.height)
                
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 1
                }
            } else {
                UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.navigationView.alpha = 0
                } completion: { _ in
                    self.navigationView.isHidden = true
                    self.allOrderViewController?.view.removeFromSuperview()
                }
            }
        }
    }
    
    func navigateToRegionalManagersPage() {
        regionalDirectorateViewController = RegionalDirectorateViewController.create()
        regionalDirectorateViewController?.delegate = self
        guard let regionalDirectorateViewController = regionalDirectorateViewController else{ return}
        
        navigationView.isHidden = false
        
        addSubView(subViewController: regionalDirectorateViewController, on: navigationView, height: navigationView.frame.height)
        
        UIView.transition(with: navigationView, duration: 0.5, options: .transitionCrossDissolve) {
            self.navigationView.alpha = 1
        }
    }
    
    func navigateToAccountingPage() {
        accountingButtonClicked()
    }
}

// MARK: -MainViewModelDelegate Methods
extension MainViewController: MainViewModelDelegate {
    func purchaseRequestSuccess(response: GetAllPurchaseResponseDTO) {
        self.homeTableView.reloadData()
    }
    
    func getAllReportsSuccess(response: GetAllReportsResponseDTO) {
        homeTableView.reloadData()
    }
    
    func getCreditLimitSuccess(response: GetCreditLimitResponseDTO) {
        homeTableView.reloadData()
    }
    
    func getCompanyAndStoreSuccess(response: GetCompanyAndStoreResponseDTO) {
        storeTitleLabel.text = response.CompanyName
        storeDescriptionLabel.text = response.StoreName
        storesViewController = StoresViewController.create(companyAndStoreModel: response)
        storesViewController?.delegate = self
        orderViewController = OrderViewController.create(currentCompanyAndStore: viewModel.currentCompanyAndStore!)
    }
    
    func advertisementRequestSuccess(response: [GetAdvertisementData]?) {
        if let _ = response {
            homeTableView.reloadData()
        }
    }
    
    func pageContentFailed(errorMessage: String) {
        self.showErrorAlert(message: errorMessage)
    }
}

// MARK: - Creator
extension MainViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "MainViewController"
        }
    }
    
    class func create(companyAndStoreModel: GetCompanyAndStoreResponseDTO?) -> MainViewController {
        let vc: MainViewController = MainViewController.instantiateFromNib()
        let viewModel: MainViewModel = MainViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        viewModel.companyAndStoreModel = companyAndStoreModel
        
        return vc
    }
}




//    MARK: - değiştirilecek -

extension UIImage {
  func withBackground(color: UIColor, fill fillColor: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, scale)
    
    guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
    defer { UIGraphicsEndImageContext() }
    
    ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
    
    let rect = CGRect(origin: .zero, size: size)
    
    // draw background
    ctx.setFillColor(color.cgColor)
    ctx.fill(rect)
    
    // draw image with fill color
    ctx.clip(to: rect, mask: image)
    ctx.setFillColor(fillColor.cgColor)
    ctx.fill(rect)
    
    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }
}
