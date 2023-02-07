//
//  OrderViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 18.08.2022.
//

import UIKit

class OrderViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: OrderViewModel!
    var allOrderViewController: AllOrderViewController?
    var orderDetailViewController: OrderDetailViewController?
    
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
        tableView.delegate = self
        tableView.dataSource = self
        
        OrderTableViewCell.registerSelf(tableView: tableView)
        AddOrderTableViewCell.registerSelf(tableView: tableView)
    }
    
    @IBAction func allOrdersButtonTapped(_ sender: UIButton) {
        let height = self.view.frame.height
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            allOrderViewController = AllOrderViewController.create(currentCompanyAndStore: currentCompanyAndStore)
            allOrderViewController?.delegate = self
            
            UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
                addSubView(subViewController: allOrderViewController!, on: self.view, height: height)
            }
        }
    }
    
    private func orderDetailClicked(orderData: OrderData) {
        let height = self.view.frame.height
        orderDetailViewController = OrderDetailViewController.create(orderData: orderData)
        orderDetailViewController?.delegate = self
        UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
            addSubView(subViewController: orderDetailViewController!, on: self.view, height: height)
        }
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ordersCount = viewModel.ordersModel?.Data?.count {
            return ordersCount + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = viewModel.ordersModel?.Data else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        
        if indexPath.row < 3 && !item.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
            cell.bind(item: item[indexPath.row])
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddOrderTableViewCell") as! AddOrderTableViewCell
            cell.delegate = self
            cell.bind()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (viewModel.ordersModel?.Data?.count ?? 0) > 0 {
            if let orderData = viewModel.ordersModel?.Data?[indexPath.row] {
                self.orderDetailClicked(orderData: orderData)
            }
        }
    }
}

//    MARK: - AllOrderViewControllerDelegate Methods -
extension OrderViewController: AllOrderViewControllerDelegate {
    func backButtonTappedInAllOrderViewController() {
        allOrderViewController?.view.removeFromSuperview()
    }
}

//    MARK: - OrderDetailViewControllerDelegate -
extension OrderViewController: OrderDetailViewControllerDelegate {
    func backButtonTappedInOrderDetaild() {
        orderDetailViewController?.view.removeFromSuperview()
    }
}


// MARK: -OrderTableViewCellDelegate Methods
extension OrderViewController: OrderTableViewCellDelegate {
    func orderItemClicked() {
        print("order item clicked")
    }
}

// MARK: -AddOrderTableViewCellDelegate Methods
extension OrderViewController: AddOrderTableViewCellDelegate {
    func addOrderClicked() {
        print("add order item clicked")
    }
}

// MARK: -OrderViewModelDelegate Methods
extension OrderViewController: OrderViewModelDelegate {
    func getOrdersSuccess() {
        tableView.reloadData()
    }
    
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}

// MARK: - Creator
extension OrderViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "OrderViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore) -> OrderViewController {
        let vc: OrderViewController = OrderViewController.instantiateFromNib()
        let viewModel: OrderViewModel = OrderViewModel()
        
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        
        viewModel.delegate = vc
        viewModel.currentCompanyAndStore = currentCompanyAndStore
        
        return vc
    }
}
