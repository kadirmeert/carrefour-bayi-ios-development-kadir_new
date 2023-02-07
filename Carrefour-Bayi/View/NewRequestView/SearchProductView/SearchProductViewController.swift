//
//  SearchProductViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 17.12.2022.
//

import UIKit


class SearchProductSection {
    var productData: ProductModel?
    var isHidden: Bool = true
    
    init(productData: ProductModel? = nil, isHidden: Bool = true) {
        self.productData = productData
        self.isHidden = isHidden
    }
}

protocol SearchProductViewControllerDelegate {
    func productSelectedInSearch(selectedProduct: ProductModel?)
}

class SearchProductViewController: BaseViewController {    
    
    //    MARK: - Properties
    var viewModel: SearchProductViewModel!
    var delegate: SearchProductViewControllerDelegate?
    
    var selectedProduct: ProductModel?
    private var sections = [SearchProductSection]()
    
    //    MARK: - Views
    @IBOutlet weak var tableView: UITableView!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        ProductResultsTableViewCell.registerSelf(tableView: tableView)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    
    @IBAction func selectButtonClicked(_ sender: Any) {
        if let selectedProduct = self.selectedProduct {
            delegate?.productSelectedInSearch(selectedProduct: selectedProduct)
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true)
        }            
    }
}





//    MARK: - TableView DataSource & Delegate
extension SearchProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductResultsTableViewCell") as! ProductResultsTableViewCell
        if let model = sections[indexPath.row].productData {
            cell.bind(model: model, isHidden: sections[indexPath.row].isHidden)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.row].isHidden.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
        selectedProduct = sections[indexPath.row].productData
    }
}





//    MARK: - SearchProductViewModelDelegate Methods
extension SearchProductViewController: SearchProductViewModelDelegate {
    func searchedProductSuccess() {
        if let productModel = viewModel.searchedProductModel {
            if !(viewModel.searchedProductModel?.isEmpty)! {
                sections = (productModel.map({ data in
                    return SearchProductSection(productData: data)
                }))
                tableView.reloadData()
            } else {
                showErrorAlert(message: "Ürün Bulunamadı")
            }
        }
    }
    
    func pageContentFailed(message: String) {
        let vc: PopupViewController = PopupViewController.create(title: message,
                                                                 description: "")
        self.present(vc, animated: true)
    }
}



// MARK: - Creator
extension SearchProductViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "SearchProductViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore,
                      requestDate: String, searchText: String) -> SearchProductViewController {
        let vc: SearchProductViewController = SearchProductViewController.instantiateFromNib()
        let viewModel: SearchProductViewModel = SearchProductViewModel()
        vc.viewModel = viewModel
        vc.viewModel.requestDate = requestDate
        vc.viewModel.searchedText = searchText
        vc.viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        return vc
    }
}
