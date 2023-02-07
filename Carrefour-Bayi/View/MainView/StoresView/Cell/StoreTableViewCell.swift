//
//  StoreTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import UIKit

class CompanyTableSection {
    var isHidden: Bool = true
    var companyAndStoreItem: CompanyAndStore
    
    init(isHidden: Bool = true, companyAndStoreItem: CompanyAndStore) {
        self.isHidden = isHidden
        self.companyAndStoreItem = companyAndStoreItem
    }
}

protocol StoreTableViewCellDelegate {
    func switchButtonChange(indexPath: IndexPath)
    func selectedStoreChanged(currentCompanyAndStore: CurrentCompanyAndStore, selectedStore: StoreItem, companyName: String, storeName: String)
}

class StoreTableViewCell: UITableViewCell {
    // MARK: -Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var topContainerView: BaseView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -Properties
    var delegate: StoreTableViewCellDelegate?
    var indexPath: IndexPath?
    var companyAndStoreSection: CompanyTableSection?
    var selectedStoreIndexPath: IndexPath?
    var storesTableSections: [StoreTableSection] = []
    
    var lastSelectedCellIndexPath: IndexPath? = nil
    
    func bind(companyAndStoreSection: CompanyTableSection, indexPath: IndexPath, storeIdForSelectedStore: Int) {
        self.companyAndStoreSection = nil
        selectedStoreIndexPath = nil
        storesTableSections = []
        
        self.companyAndStoreSection = companyAndStoreSection
        
        if let stores = companyAndStoreSection.companyAndStoreItem.Stores {
            storesTableSections = stores.map({ storeItem in
                if storeItem.Id == storeIdForSelectedStore {
                    return StoreTableSection(isSelected: true, isActive: true, storeItem: storeItem)
                }
                else {
                    return StoreTableSection(isSelected: false, isActive: false, storeItem: storeItem)
                }
            })
        }
        
        self.indexPath = indexPath
        
        storeNameLabel.text = companyAndStoreSection.companyAndStoreItem.CompanyName
        
        switchButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        switchButton.backgroundColor = .primaryRed
        switchButton.onTintColor = .primaryDarkBlue
        switchButton.layer.cornerRadius = 16
        switchButton.isOn = !companyAndStoreSection.isHidden
    
        bottomContainerView.isHidden = companyAndStoreSection.isHidden
        
        topContainerView.backgroundColor = companyAndStoreSection.isHidden ? .thirdDarkBlue : .white
        titleLabel.textColor = companyAndStoreSection.isHidden ? .white : .thirdDarkBlue
        storeNameLabel.textColor = companyAndStoreSection.isHidden ? .white : .primaryDarkBlue
        
        StoreItemTableViewCell.registerSelf(tableView: tableView)
        ChangeStoreTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    @IBAction func switchButtonChanged(_ sender: UISwitch) {
        if let indexPath = indexPath {
            delegate?.switchButtonChange(indexPath: indexPath)
        }
    }
    
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension StoreTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesTableSections.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !storesTableSections.isEmpty {
            if indexPath.row == storesTableSections.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeStoreTableViewCell") as! ChangeStoreTableViewCell
                cell.bind()
                cell.delegate = self
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoreItemTableViewCell") as! StoreItemTableViewCell
                cell.bind(section: storesTableSections[indexPath.row])
                
                return cell
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(companyAndStoreSection?.companyAndStoreItem.Stores?.isEmpty ?? false) {
            if let lastSelectedCellIndexPath = lastSelectedCellIndexPath {
                storesTableSections[lastSelectedCellIndexPath.row].isSelected = false
                storesTableSections[indexPath.row].isSelected = true
                storesTableSections[lastSelectedCellIndexPath.row].isActive = false
                storesTableSections[indexPath.row].isActive = true
                tableView.reloadRows(at: [indexPath, lastSelectedCellIndexPath], with: .fade)
            } else {
                storesTableSections[indexPath.row].isSelected = true
                storesTableSections[indexPath.row].isActive = true
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            selectedStoreIndexPath = indexPath
            self.lastSelectedCellIndexPath = indexPath
        }
    }
}

// MARK: -ChangeStoreTableViewCellDelegate Methods
extension StoreTableViewCell: ChangeStoreTableViewCellDelegate {
    func changeStoreButtonClicked() {
        if let selectedStoreIndexPath = selectedStoreIndexPath {
            storesTableSections[selectedStoreIndexPath.row].isActive = true
            tableView.reloadRows(at: [selectedStoreIndexPath], with: .fade)
            
            let companyID   = storesTableSections[selectedStoreIndexPath.row].storeItem.CompanyId!
            let storeID     = storesTableSections[selectedStoreIndexPath.row].storeItem.Id!
            let sapCode     = Int(storesTableSections[selectedStoreIndexPath.row].storeItem.SAPCode!)!
            let companyCode = companyAndStoreSection?.companyAndStoreItem.CompanyCode
            let currentCompanyAndStore = CurrentCompanyAndStore(companyID: companyID, storeID: storeID,
                                                                sapCode: sapCode, companyCode: companyCode ?? "0")
            
            delegate?.selectedStoreChanged(currentCompanyAndStore: currentCompanyAndStore,
                                           selectedStore: storesTableSections[selectedStoreIndexPath.row].storeItem,
                                           companyName: companyAndStoreSection?.companyAndStoreItem.CompanyName ?? "",
                                           storeName: storesTableSections[selectedStoreIndexPath.row].storeItem.Name!)
        }
    }
}
