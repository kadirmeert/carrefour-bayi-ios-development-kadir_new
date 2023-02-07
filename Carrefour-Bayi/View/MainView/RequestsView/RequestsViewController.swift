//
//  RequestsViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 19.08.2022.
//

import UIKit


class RequestsViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: RequestsViewModel!
    var allRequestViewController: AllRequestViewController?
    var requestDetailViewController: RequestDetailViewController?
    var newRequestViewController: NewRequestViewController?
    
    var isNewRequestViewUp: Bool = false
    
    // MARK: -Views
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        RequestsTableViewCell.registerSelf(tableView: tableView)
        AddRequestTableViewCell.registerSelf(tableView: tableView)
    }
    
    @IBAction func allRequestsButtonClicked(_ sender: UIButton) {
        let height = self.view.frame.height
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            allRequestViewController = AllRequestViewController.create(currentCompanyAndStore: currentCompanyAndStore)
            allRequestViewController?.delegate = self
            
            UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
                addSubView(subViewController: allRequestViewController!, on: self.view, height: height)
            }
        }
    }
    
    private func requestDetailClicked(requestData: PurchaseRequestData) {
        let height = self.view.frame.height
        requestDetailViewController = RequestDetailViewController.create(requestData: requestData)
        requestDetailViewController?.delegate = self
        UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
            addSubView(subViewController: requestDetailViewController!, on: self.view, height: height)
        }
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension RequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataCount = viewModel.purchaseRequestResponseModel?.Data?.count {
            return dataCount + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = viewModel.purchaseRequestResponseModel?.Data else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddRequestTableViewCell") as! AddRequestTableViewCell
            cell.bind()
            cell.delegate = self
            return cell            
        }
        
        if indexPath.row < 3 && !item.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsTableViewCell") as! RequestsTableViewCell
            if let requestModel = viewModel.purchaseRequestResponseModel {
                cell.bind(requestModel: requestModel.Data![indexPath.row])
                cell.delegate = self
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddRequestTableViewCell") as! AddRequestTableViewCell
            cell.bind()
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let requestData = viewModel.purchaseRequestResponseModel?.Data?[indexPath.row] {
            self.requestDetailClicked(requestData: requestData)
        }
    }
}

//    MARK: - AllRequestViewControllerDelegate Methods -
extension RequestsViewController: AllRequestViewControllerDelegate {
    func backButtonTapped() {
        allRequestViewController?.view.removeFromSuperview()
    }
}

//    MARK: - RequestDetailViewControllerDelegate -
extension RequestsViewController: RequestDetailViewControllerDelegate {
    func deleteButtonClicked(id: Int) {
         
    }
    
    func backButtonTappedInRequestDetailDet() {
        requestDetailViewController?.view.removeFromSuperview()
    }
}

// MARK: -RequestsTableViewCellDelegate Methods
extension RequestsViewController: RequestsTableViewCellDelegate {
    func requestItemClicked() {
    }
}

//    MARK: - NewRequestViewControllerDelegate
extension RequestsViewController: NewRequestViewControllerDelegate {
    func backButtonTappedInNewRequest() {
        addRequestClicked()
    }
}

// MARK: -RequestsTableViewCellDelegate Methods
extension RequestsViewController: AddRequestTableViewCellDelegate {
    func addRequestClicked() {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore {
            isNewRequestViewUp.toggle()
            if isNewRequestViewUp {
                let height = self.view.frame.height
                newRequestViewController = NewRequestViewController.create(currentCompanyAndStore: currentCompanyAndStore)
                newRequestViewController?.delegate = self
                self.view.isHidden = false
                addSubView(subViewController: newRequestViewController!, on: self.view, height: height)
                UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve) {
                    self.view.alpha = 1
                }
            } else {
                UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve) {
                    self.newRequestViewController?.view.alpha = 0
                } completion: { _ in
                    self.newRequestViewController?.view.isHidden = true
                    self.newRequestViewController?.view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: -RequestsViewModelDelegate Methods
extension RequestsViewController: RequestsViewModelDelegate {
    
}

// MARK: - Creator
extension RequestsViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "RequestsViewController"
        }
    }
    
    class func create(purchaseRequestResponseModel: GetAllPurchaseResponseDTO, currentCompanyAndStore: CurrentCompanyAndStore?) -> RequestsViewController {
        let vc: RequestsViewController = RequestsViewController.instantiateFromNib()
        let viewModel: RequestsViewModel = RequestsViewModel()
        vc.viewModel = viewModel
        vc.viewModel.purchaseRequestResponseModel = purchaseRequestResponseModel
        vc.viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
