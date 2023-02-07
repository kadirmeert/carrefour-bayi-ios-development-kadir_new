//
//  StoresViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 1.09.2022.
//

import UIKit

class CompanySection {
    let companyAndStore: CompanyAndStore
    var isHidden: Bool = true
    
    init(companyAndStore: CompanyAndStore, isHidden: Bool = true) {
        self.companyAndStore = companyAndStore
        self.isHidden = isHidden
    }
}

protocol StoresViewControllerDelegate {
    func selectedStoreChanged(currentCompanyAndStore: CurrentCompanyAndStore, companyName: String, storeName: String)
}

class StoresViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: StoresViewModel!
    var delegate: StoresViewControllerDelegate?
    var lastSelectedStoreIndexPath: IndexPath? = nil
    
    // MARK: -Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastSelectedStoreIndexPath = nil
    }
    
    // MARK: -UI Methods
    private func initUI() {
        titleLabel.text = "storesViewTitle".localized
        titleLabel.isHidden = true
        StoreTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func controlTableViewRows(currentIndexPath: IndexPath) {
        viewModel.companyTableSections[currentIndexPath.row].isHidden.toggle()
        if let lastStoreIndexPath = lastSelectedStoreIndexPath {
            viewModel.companyTableSections[lastStoreIndexPath.row].isHidden.toggle()
            tableView.reloadRows(at: [currentIndexPath, lastStoreIndexPath], with: .fade)
        } else {
            tableView.reloadRows(at: [currentIndexPath], with: .fade)
        }
        lastSelectedStoreIndexPath = currentIndexPath
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension StoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.companyTableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as! StoreTableViewCell
        
        if !viewModel.companyTableSections.isEmpty {
            if let selectedStore = viewModel.selectedStore {
                cell.bind(companyAndStoreSection: viewModel.companyTableSections[indexPath.row],
                          indexPath: indexPath, storeIdForSelectedStore: selectedStore.Id ?? 0)
            }
            else {
                cell.bind(companyAndStoreSection: viewModel.companyTableSections[indexPath.row],
                          indexPath: indexPath, storeIdForSelectedStore: viewModel.companyAndStoreModel?.StoreId ?? 0)
            }
            
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controlTableViewRows(currentIndexPath: indexPath)
    }
}

// MARK: -PopupViewControllerDelegate Methods
extension StoresViewController: PopupViewControllerDelegate {
    func popupClosed() {
        if let selectedStore = viewModel.selectedStore, let currentCompAndSt = viewModel.currentCompanyAndStore {
            delegate?.selectedStoreChanged(currentCompanyAndStore: currentCompAndSt,
                                           companyName: viewModel.selectedCompanyName!,
                                           storeName: viewModel.selectedStoreName!)
        }
    }
}

// MARK: -StoreTableViewCellDelegate Methods
extension StoresViewController: StoreTableViewCellDelegate {
    func selectedStoreChanged(currentCompanyAndStore: CurrentCompanyAndStore, selectedStore: StoreItem,
                              companyName: String, storeName: String) {
        viewModel.changeSelectedStore(selectedStore: selectedStore)
        viewModel.selectedCompanyName = companyName
        viewModel.selectedStoreName = storeName
        viewModel.currentCompanyAndStore = currentCompanyAndStore
        let vc: PopupViewController = PopupViewController.create(title: "Hesap değiştirme işlemi başarılı.",
                                                                 description: "Cari Adı: \(companyName)\nMağaza: \(selectedStore.Name ?? "")")
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
    
    func switchButtonChange(indexPath: IndexPath) {
        controlTableViewRows(currentIndexPath: indexPath)
    }
}

// MARK: -StoresViewModelDelegate Methods
extension StoresViewController: StoresViewModelDelegate {
    func pageContentSuccess() {
        tableView.reloadData()
        titleLabel.isHidden = false
    }
    
    func pageContentFailed(message: String) {
        self.showErrorAlert(message: message)
    }
}

// MARK: - Creator
extension StoresViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "StoresViewController"
        }
    }
    
    class func create(companyAndStoreModel: GetCompanyAndStoreResponseDTO) -> StoresViewController {
        let vc: StoresViewController = StoresViewController.instantiateFromNib()
        let viewModel: StoresViewModel = StoresViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        viewModel.companyAndStoreModel = companyAndStoreModel
        
        return vc
    }
}
