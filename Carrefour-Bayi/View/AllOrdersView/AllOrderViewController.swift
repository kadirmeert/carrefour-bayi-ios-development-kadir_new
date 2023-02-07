//
//  AllOrderViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import UIKit
import LGButton


class AllOrderSection {
    var orderData: OrderData?
    var isHidden: Bool = true
    
    init(orderData: OrderData? = nil, isHidden: Bool = true) {
        self.orderData = orderData
        self.isHidden = isHidden
    }
}



protocol AllOrderViewControllerDelegate {
    func backButtonTappedInAllOrderViewController()
}



class AllOrderViewController: BaseViewController {

    //    MARK: - Properties -
    var viewModel: AllOrderViewModel!
    var orderDetailViewController: OrderDetailViewController?
    var delegate: AllOrderViewControllerDelegate?
    var error404ViewController = Error404ViewController.create()
    private var sections = [AllOrderSection]()
    private let minDatePicker: UIDatePicker = UIDatePicker()
    private let maxDatePicker: UIDatePicker = UIDatePicker()
    var minDateForEndpoint: String?
    var maxDateForEndpoint: String?
    var isFilteredExpanded: Bool = false
    var selectedOrderStateFilter: Int?
    var selectedOrder: OrderData?
    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var minimizedFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var expandedFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var filterViewExpandedView: UIView!
    @IBOutlet weak var filterViewMinimizedView: UIView!
    @IBOutlet weak var orderStatusFilterTextField: UITextField!
    @IBOutlet weak var minOrderDateFilterTextField: UITextField!
    @IBOutlet weak var maxOrderDateFilterTextField: UITextField!
    @IBOutlet weak var orderNoTextField: UITextField!
    @IBOutlet weak var minCostTextField: UITextField!
    @IBOutlet weak var maxCostTextField: UITextField!
    @IBOutlet weak var orderStateButton: UIButton!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    
    //    MARK: - UI Methods -
    private func initUI() {
        tableView.register(AllOrderTableViewCell.nib, forCellReuseIdentifier: AllOrderTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        initFilterUI()
        if #available(iOS 14.0, *) {
            initStateField()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func initFilterUI(){
        filterViewExpandedView.isHidden = true
        filterViewMinimizedView.isHidden = false
        expandedFilterHeight.constant = 0
        
        minDatePicker.datePickerMode = .date
        minDatePicker.maximumDate = Date()
        minDatePicker.locale = Locale(identifier: "tr_TR")
        minDatePicker.date = Date()
        
        maxDatePicker.datePickerMode = .date
        maxDatePicker.maximumDate = Date()
        maxDatePicker.locale = Locale(identifier: "tr_TR")
        maxDatePicker.date = Date()
        
        if #available(iOS 13.4, *) {
            minDatePicker.preferredDatePickerStyle = .wheels
            maxDatePicker.preferredDatePickerStyle = .wheels
        }
        minOrderDateFilterTextField.inputView = minDatePicker
        maxOrderDateFilterTextField.inputView = maxDatePicker
        minCostTextField.keyboardType = .decimalPad
        maxCostTextField.keyboardType = .decimalPad
        
        let lastWeekDate = NSCalendar.current.date(byAdding: .weekOfYear, value: -1, to: NSDate() as Date)
        
        minOrderDateFilterTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.firstDateSelected(_:)))
        maxOrderDateFilterTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.lastDateSelected(_:)))
        
    }
    
    @available(iOS 14.0, *)
    private func initStateField(){
        let orderReceived = UIAction(title: "Siparişiniz Alındı") { [self] action in
            selectedOrderStateFilter = 1
            orderStatusFilterTextField.text = "Siparişiniz Alındı"
        }
        let menu = UIMenu(title: "Sipariş Durumu", identifier: UIMenu.Identifier("menu"), options: .displayInline, children: [orderReceived])
        orderStateButton.menu = menu
        orderStateButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func firstDateSelected(_ sender: Any) {
        minOrderDateFilterTextField.text = viewModel.fieldsDateFormatter.string(from: minDatePicker.date)
        minDateForEndpoint = viewModel.endpointDateFormatter.string(from: minDatePicker.date)
        //todo: update view model to get api call
    }
    
    @objc func lastDateSelected(_ sender: Any) {
        maxOrderDateFilterTextField.text = viewModel.fieldsDateFormatter.string(from: maxDatePicker.date)
        maxDateForEndpoint = viewModel.endpointDateFormatter.string(from: maxDatePicker.date)
        //todo: update view model to get api call
    }
   
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.backButtonTappedInAllOrderViewController()
    }
    
    @IBAction func filterRetryButtonClicked(_ sender: Any) {
        minOrderDateFilterTextField.text = ""
        maxOrderDateFilterTextField.text = ""
        minCostTextField.text = ""
        maxCostTextField.text = ""
        orderStatusFilterTextField.text = ""
        selectedOrderStateFilter = nil
        orderNoTextField.text = ""
        minDateForEndpoint = ""
        maxDateForEndpoint = ""
        isFilteredExpanded = false
    }
    
    @IBAction func filterCloseButtonClicked(_ sender: Any) {
        filterViewExpandedView.isHidden = true
        filterViewMinimizedView.isHidden = false
        minimizedFilterHeight.constant = 66
        expandedFilterHeight.constant = 0
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        filterViewExpandedView.isHidden = false
        filterViewMinimizedView.isHidden = true
        minimizedFilterHeight.constant = 0
        expandedFilterHeight.constant = 405
    }
    
    
    @IBAction func getFilteredOrdersButtonClicked(_ sender: LGButton) {
        isFilteredExpanded = true
        let orderNumber: String? = orderNoTextField.text == "" ? nil : orderNoTextField.text
        let minDate: String? = minDateForEndpoint == "" ? nil : minDateForEndpoint
        let maxDate: String? = maxDateForEndpoint == "" ? nil : maxDateForEndpoint
        let orderState: Int? = selectedOrderStateFilter
        let maxPrice: Double? = maxCostTextField.text == "" ? nil : Double((maxCostTextField.text!).replacingOccurrences(of: ",", with: "."))
        let minPrice: Double? = minCostTextField.text == "" ? nil : Double((minCostTextField.text!).replacingOccurrences(of: ",", with: "."))
        viewModel.getFilteredOrders(orderNumber: orderNumber,
                                    firstDate: minDate,
                                    lastDate: maxDate,
                                    orderState: orderState, maxPrice: maxPrice,
                                    minPrice: minPrice) {
        }
    }
}






//    MARK: - TableView Methods -
extension AllOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllOrderTableViewCell") as! AllOrderTableViewCell
        if let orderData = sections[indexPath.row].orderData {
            cell.bind(orderData: orderData, isHidden: sections[indexPath.row].isHidden)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.row].isHidden.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
        selectedOrder = sections[indexPath.row].orderData
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == sections.count - 1 {
            if isFilteredExpanded {
                    let dataCount = sections.count
                    viewModel.getMoreFilteredOrders { [self] in
                        sections = (viewModel.ordersModel?.Data?.map({ data in
                            return AllOrderSection(orderData: data)
                        }))!
                        if sections.count > dataCount {
                            tableView.reloadData()
                        }
                    }
            } else {
                viewModel.getMoreOrders { [self] in
                    let dataCount = sections.count
                    sections = (viewModel.ordersModel?.Data?.map({ data in
                        return AllOrderSection(orderData: data)
                    }))!
                    if sections.count > dataCount {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}






//    MARK: - AllOrderTableViewCellDelegate Methods -
extension AllOrderViewController: AllOrderTableViewCellDelegate {
    func orderDetailsClicked() {
        let height = self.view.frame.height
        if let selectedOrderData = selectedOrder {
            orderDetailViewController = OrderDetailViewController.create(orderData: selectedOrderData)
            orderDetailViewController?.delegate = self
            
            UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
                addSubView(subViewController: orderDetailViewController!, on: self.view, height: height)
            }
        }
    }
}




//    MARK: - OrderDetailViewControllerDelegate Methods -
extension AllOrderViewController: OrderDetailViewControllerDelegate {
    func backButtonTappedInOrderDetaild() {
        orderDetailViewController?.view.removeFromSuperview()
    }
}






//    MARK: - AllOrderViewModelDelegate Methods -
extension AllOrderViewController: AllOrderViewModelDelegate {
    func pageContentSuccess() {
        if let ordersModel = viewModel.ordersModel {
            if !(viewModel.ordersModel?.Data!.isEmpty)! {
                sections = (viewModel.ordersModel?.Data?.map({ data in
                    return AllOrderSection(orderData: data)
                }))!
                tableView.reloadData()
            } else {
                showErrorAlert(message: ordersModel.Message ?? "generalErrorMessage".localized)
            }
        }
    }
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}






// MARK: - Creator
extension AllOrderViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "AllOrderViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore) -> AllOrderViewController {
        let vc: AllOrderViewController = AllOrderViewController.instantiateFromNib()
        let viewModel: AllOrderViewModel = AllOrderViewModel()
        vc.viewModel = viewModel
        vc.viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
