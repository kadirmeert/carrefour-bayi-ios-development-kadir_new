//
//  NewRequestViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 9.12.2022.
//

import UIKit


protocol NewRequestViewControllerDelegate {
    func backButtonTappedInNewRequest()
}

class NewRequestViewController: BaseViewController {
 
    
    //    MARK: - Properties
    var viewModel: NewRequestViewModel!
    var delegate: NewRequestViewControllerDelegate?
    var searchProductViewController: SearchProductViewController?
    
    var filteredProductModelNames: Array = [String]()
    var filteredProductModelIds: Array = [Int]()
    
    var purchaseRequestDetailData: [PurchaseRequestDetailData]?
    var currentCompanyAndStore: CurrentCompanyAndStore?
                                       
    var savedRequestDate: String?
    var selectedProductAmount: Int?
    var areCellsHidden: Bool = true
    var searchProductViewIsUp: Bool = false
    var isAmountCellEnable: Bool = false
    
    var isSelectedAisle: Bool = false
    var searchAisleCode: Int?
    var searchProductId: Int?
    var selectedProductName: String?
    var isDeleteSuccess: Bool = false
    var isUpdateSuccess: Bool = false
    var isSelectedProduct: Bool = false
    var isInfoNotSuccess: Bool = false
    
    var productAmount: Int?
    var amountMultiplier: Float?
    var maxAmount: Int?
    
    var productQuantity: Int?
    var updateQuantity: Int?
    
    var productId: Int?
    var purchaseRequestId: Int?
    var requestId: Int?

    //    MARK: - Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newRequestBaseView: UIView!
    @IBOutlet weak var sendRequestBaseView: UIView!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        RequestInfoTableViewCell.registerSelf(tableView: tableView)
        ProductCategoriesTableViewCell.registerSelf(tableView: tableView)
        SelectProductTableViewCell.registerSelf(tableView: tableView)
        ProductSelectionTableViewCell.registerSelf(tableView: tableView)
        GetRequestsTableViewCell.registerSelf(tableView: tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegate?.backButtonTappedInNewRequest()
    }
    
    @IBAction func sendRequestButtonTapped(_ sender: UIButton) {
        viewModel.sendRequest(purchaseRequestId: self.purchaseRequestId)
    }
}







//    MARK: - TableView Methods
extension NewRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestInfoTableViewCell") as! RequestInfoTableViewCell
            if let serialNumber = viewModel.getSerialNumberResponseModel?.SerialNumber,
               let currentCompanyAndStore = viewModel.currentCompanyAndStore {
                cell.bind(requestNo: serialNumber, requestDate: self.savedRequestDate)
                cell.currentCompanyAndStore = currentCompanyAndStore
                cell.delegate = self
            }
            return cell            
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCategoriesTableViewCell") as! ProductCategoriesTableViewCell
            cell.isHidden = areCellsHidden
            if let aisleModel = viewModel.aislesModel, aisleModel.count > 0, 
               let currentCompanyAndStore = viewModel.currentCompanyAndStore {
                if (searchAisleCode != nil) {
                    cell.search(aislesModel: aisleModel, searchAisleCode: searchAisleCode ?? 0 )
                    cell.viewModel.currentCompanyAndStore = currentCompanyAndStore
                    cell.delegate = self
                } else {
                    cell.bind(aislesModel: aisleModel)
                    cell.viewModel.currentCompanyAndStore = currentCompanyAndStore
                    cell.delegate = self
                }
            }
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectProductTableViewCell") as! SelectProductTableViewCell
            cell.isHidden = areCellsHidden
            if (viewModel.getProductsByProductNameModel != nil) {
                for i in 0..<(viewModel.getProductsByProductNameModel?.getProductsFilteredDtos?.count ?? 0)  {
                    filteredProductModelNames.append(viewModel.getProductsByProductNameModel?.getProductsFilteredDtos?[i].Name ?? "")
                    filteredProductModelIds.append(viewModel.getProductsByProductNameModel?.getProductsFilteredDtos?[i].Id ?? 0)
                    cell.bind(filteredProductModelName: filteredProductModelNames,
                              isSelectedAisle: isSelectedAisle,
                              selectedProductName: selectedProductName ?? "",
                              selectedProductId: searchProductId ?? 0, filteredProductModelId: filteredProductModelIds,
                              infoProductFromStockId: viewModel.getProductInfoFromStocksModel?.getProductInfoFromStoklarDtos,
                              isSelectedProduct: isSelectedProduct, isInfoNotSuccess: self.isInfoNotSuccess)
                    cell.delegate = self
                }
            }
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSelectionTableViewCell") as! ProductSelectionTableViewCell
            cell.isHidden = areCellsHidden
            if let currentCompanyAndStore = viewModel.currentCompanyAndStore,
               let purchaseRequestId = viewModel.createPurchaseResponseModel?.PurchaseRequestId {
                let maximumAmount = viewModel.getProductInfoFromStocksModel?.getProductInfoFromStoklarDtos?.sto_prim_orani ?? 0
                let amountMultiplier = viewModel.getProductInfoFromStocksModel?.getProductInfoFromStoklarDtos?.sto_birim2_katsayi ?? 0
                cell.viewModel.currentCompanyAndStore = currentCompanyAndStore
                cell.bind(purchaseRequestId: purchaseRequestId, productId: productId, isSelectedProduct: isSelectedProduct,
                          isDeleteSuccess: self.isDeleteSuccess, maximumAmount: maximumAmount, amountMultiplier: Int(amountMultiplier),
                          isUpdateSuccess: self.isUpdateSuccess, updateQuantity: self.updateQuantity ?? 0)
                cell.isAmountEnable = isAmountCellEnable
                cell.delegate = self
            }
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GetRequestsTableViewCell") as! GetRequestsTableViewCell
            cell.isHidden = areCellsHidden
            let purchaseRequestId = viewModel.createPurchaseResponseModel?.PurchaseRequestId
            cell.bind(purchaseRequestDetailData: self.purchaseRequestDetailData, purchaseRequestId: purchaseRequestId,
                      productAmount: self.productAmount, amountMultiplier: Int(self.amountMultiplier ?? 1), maxAmount: self.maxAmount,
                      productQuantity: self.productQuantity)
            cell.delegate = self
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}




    

//    MARK: - RequestInfo TableViewCellDelegate methods
extension NewRequestViewController: RequestInfoTableViewCellDelegate {
    func saveRequestInfoClickedInRequestInfoCell(requestNo: String, requestDateForService: String,
                                                 requestDateForUser: String) {
         viewModel.createPurchaseRequest(requestNo: requestNo, requestDate: requestDateForService)
        self.savedRequestDate = requestDateForUser
    }
}






//    MARK: - SearchProduct ViewControllerDelegate
extension NewRequestViewController: SearchProductViewControllerDelegate {
    func productSelectedInSearch(selectedProduct: ProductModel?) {
        searchAisleCode = selectedProduct?.ReyonKodu
        searchProductId = selectedProduct?.ProductId
        viewModel.getAisles()
    }
}






//    MARK: - ProductCategories TableViewCellDelegate Methods
extension NewRequestViewController: ProductCategoriesTableViewCellDelegate {
    func getAllParameters(ReyonKodu: Int, AnaGrupKodu: Int, AnaHamKodu: Int, MalGrupKodu: Int) {
        if let storeSAPCode = viewModel.currentCompanyAndStore?.sapCode {
            let requestModel: GetProductsFilteredRequestDTO = GetProductsFilteredRequestDTO(StoreSAPCode: storeSAPCode,
                                                                                            ReyonKodu: ReyonKodu,
                                                                                            AnaGrupKodu: AnaHamKodu,
                                                                                            AnaHamKodu: AnaGrupKodu,
                                                                                            MalGrupKodu: MalGrupKodu,
                                                                                            Language: ServiceConfiguration.Language,
                                                                                            ProcessType: ServiceConfiguration.ProcessType)
            viewModel.getProductsFiltered(requestModel: requestModel)
            filteredProductModelNames.removeAll()
            filteredProductModelIds.removeAll()
            isSelectedAisle = false
        }
    }
    
    func contentFailed(message: String) {
        let vc: PopupViewController = PopupViewController.create(title: message,
                                                                 description: "")
        self.present(vc, animated: true)
    }
    
    func searchProductClicked(searchText: String) {
        if let currentCompanyAndStore = viewModel.currentCompanyAndStore, let savedRequestDate = savedRequestDate {
            searchProductViewController = SearchProductViewController.create(currentCompanyAndStore: currentCompanyAndStore,
                                                                             requestDate: savedRequestDate, searchText: searchText)
            searchProductViewController?.delegate = self
            searchProductViewController?.modalTransitionStyle = .crossDissolve
            self.present(searchProductViewController!, animated: true)
        }
    }
    
    func productSelectedSuccess(products: AisleModel) {
        
    }
}







//    MARK: - SelectedProduct TableViewCellDelegate methods
extension NewRequestViewController: SelectProductTableViewCellDelegate {
    func productByProductModelId(productId: Int?, isSelectedProduct: Bool?) {
        if let storeSAPCode = viewModel.currentCompanyAndStore?.sapCode {
            let requestModel: GetProductInfoFromStocksRequestDTO = GetProductInfoFromStocksRequestDTO(ProductId: productId ?? 0,
                                                                                                       SAPCode: storeSAPCode,
                                                                                                       Language: ServiceConfiguration.Language,
                                                                                                       ProcessType: ServiceConfiguration.ProcessType)
            viewModel.getProductInfoFromStocks(requestModel: requestModel)
            self.productId = productId
            self.isSelectedProduct = isSelectedProduct ?? Bool()
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
        }
    }
    
    func productButtonToggled(productName: String?) {
        isSelectedAisle.toggle()
        selectedProductName = productName
        filteredProductModelNames.removeAll()
        filteredProductModelIds.removeAll()
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
    }
    
    func productSelectionRemoved() {
        self.isSelectedProduct = false
        tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
    }
}








//    MARK: - ProductSelectionTableViewCellDelegate
extension NewRequestViewController: ProductSelectionTableViewCellDelegate {
    func searchedProductByBarcodeSuccess(response: GetProductByBarcodeResponseDTO) {
        
    }
    
    func searchedProductByStockCodeSuccess(response: GetProductByStockCodeResponseDTO) {
        
    }
    
    func sendPurchaseRequestId(purchaseRequestId: Int) {
        self.purchaseRequestId = purchaseRequestId
    }
    
    func purchaseRequestDetailData(modelData: [PurchaseRequestDetailData]?) {
        self.purchaseRequestDetailData = modelData
        tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .fade)
    }
    
    func contentFailedInProductSelection(message: String) {
        contentFailed(message: message)
    }
    
    func addProductClickedInNewRequest() {
        
    }
    
    func productAmountChanged(productAmount: Int) {
        self.productAmount = productAmount
    }
}










//    MARK: - GetRequestsTableViewCell Delegate methods
extension NewRequestViewController: GetRequestsTableViewCellDelegate {
    func updateProductQuantitySuccess(isUpdateQuantity: Bool) {
    self.isUpdateSuccess = isUpdateQuantity
    tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
}
    func UpdateProductQuantity(vc: UpdateProductQuantityViewController) {
        self.present(vc, animated: true)
    }
    
    func deletePurchaseRequestDetailSuccess(isDeleteSucces: Bool) {
        if isDeleteSucces == isDeleteSucces {
            self.isDeleteSuccess = isDeleteSucces
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
        }
    }
    
    func contentFailedInGetRequest(message: String) {
         
    }
}






//    MARK: - NewRequest ViewModelDelegate Methods
extension NewRequestViewController: NewRequestViewModelDelegate {
    func getSerialNumberSuccess() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    func createPurchaseRequestSuccess() {
        viewModel.getAisles()
    }
    
    func getAislesSuccess() {
        if let _ = viewModel.aislesModel {
            areCellsHidden = false
            for i in 0...3 {
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
            }
        } else {
            let vc: PopupViewController = PopupViewController.create(title: "Bugün için ekleyebileceğiniz bir ürün bulunamadı.",
                                                                     description: "")
            self.present(vc, animated: true)
        }
    }
    
    
    func getProductInfoFromStocksSuccess() {
        if let _ = viewModel.getProductInfoFromStocksModel {
            areCellsHidden = false
            isInfoNotSuccess = false
            amountMultiplier = viewModel.getProductInfoFromStocksModel?.getProductInfoFromStoklarDtos?.sto_birim2_katsayi
            maxAmount = viewModel.getProductInfoFromStocksModel?.getProductInfoFromStoklarDtos?.sto_prim_orani
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
        } else {
            let vc: PopupViewController = PopupViewController.create(title: "Ürün detayı bulunamadı.",
                                                                     description: "")
            self.present(vc, animated: true)
        }
    }
    
    
    
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
    
    func pageContentInfoFailed(message: String) {
        self.isInfoNotSuccess = true
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
    }
    
    func getProductsFilteredSuccess() {
        if let _ = viewModel.getProductsByProductNameModel {
            areCellsHidden = false
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
        } else {
            let vc: PopupViewController = PopupViewController.create(title: "Bugün için ekleyebileceğiniz bir ürün bulunamadı.",
                                                                     description: "")
            self.present(vc, animated: true)
        }
    }
    
    func sendRequestSuccess() {
        let vc: PopupViewController = PopupViewController.create(title: "Talep Gönderildi.", description: "")
        self.present(vc, animated: true)
        delegate?.backButtonTappedInNewRequest()
    }
}






// MARK: - Creator
extension NewRequestViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "NewRequestViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore) -> NewRequestViewController {
        let vc: NewRequestViewController = NewRequestViewController.instantiateFromNib()
        let viewModel: NewRequestViewModel = NewRequestViewModel()
        viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
