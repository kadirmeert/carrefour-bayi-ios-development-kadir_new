//
//  DashboardRequestsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import UIKit

protocol DashboardRequestTableViewCellDelegate {
    func allRequestButtonTapped()
    func requestDetailTapped(requestData: PurchaseRequestData?)
    func addRequestButtonTapped()
}

class DashboardRequestsTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -Properties
    var requestsModel: GetAllPurchaseResponseDTO?
    var delegate: DashboardRequestTableViewCellDelegate?
    
    // MARK: -UI Methods
    func bind(requestsModel: GetAllPurchaseResponseDTO) {
        self.addShadow()
        self.requestsModel = requestsModel
        DashboardRequestsItemTableViewCell.registerSelf(tableView: tableView)
        AddDashboardRequestTableViewCell.registerSelf(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func allRequestsButtonClicked(_ sender: UIButton) {
        delegate?.allRequestButtonTapped()
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension DashboardRequestsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataCount = requestsModel?.Data?.count {
            return dataCount + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = requestsModel?.Data else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDashboardRequestTableViewCell") as! AddDashboardRequestTableViewCell
            cell.delegate = self
            cell.bind()
            return cell

        }
        
        if indexPath.row < 5 && !item.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardRequestsItemTableViewCell") as! DashboardRequestsItemTableViewCell
            
            if let requestsModel = requestsModel, let data = requestsModel.Data, indexPath.row <= data.count - 1 {
                cell.bind(requestModel: data[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDashboardRequestTableViewCell") as! AddDashboardRequestTableViewCell
            cell.delegate = self
            cell.bind()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let requestData = requestsModel?.Data?[indexPath.row - 1] {
            delegate?.requestDetailTapped(requestData: requestData)
        }
    }
}

// MARK: -AddDashboardRequestTableViewCellDelegate Methods
extension DashboardRequestsTableViewCell: AddDashboardRequestTableViewCellDelegate {
    func addRequestClicked() {
        delegate?.addRequestButtonTapped()
    }
}


