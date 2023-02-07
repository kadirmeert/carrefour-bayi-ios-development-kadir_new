//
//  AllRequestViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 7.11.2022.
//

import UIKit
import MobileCoreServices
import LGButton

class AllRequestSection {
    var requestData: PurchaseRequestData?
    var isHidden: Bool = true
    
    init(requestData: PurchaseRequestData? = nil, isHidden: Bool = true) {
        self.requestData = requestData
        self.isHidden = isHidden
    }
}

protocol AllRequestViewControllerDelegate {
    func backButtonTapped()
}

class AllRequestViewController: BaseViewController {
    

    //    MARK: - Properties -
    var viewModel: AllRequestViewModel!
    var delegate: AllRequestViewControllerDelegate?
    var error404ViewController = Error404ViewController.create()
    private var sections = [AllRequestSection]()
    private let minDatePicker: UIDatePicker = UIDatePicker()
    private let maxDatePicker: UIDatePicker = UIDatePicker()
    var minDateForEndpoint: String?
    var maxDateForEndpoint: String?
    var isFilteredExpanded: Bool = false
    var selectedRequestStateFilter: Int?
    var requestDetailViewController: RequestDetailViewController?
    var selectedRequest: PurchaseRequestData?
    var newRequestViewController: NewRequestViewController?
    var isNewRequestViewUp: Bool = false

    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var minimizedFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var expandedFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var filterViewMinimizedView: UIView!
    @IBOutlet weak var filterViewExpandedView: UIView!
    @IBOutlet weak var requestStatusFilterTextField: UITextField!
    @IBOutlet weak var minRequestDateFilterTextField: UITextField!
    @IBOutlet weak var maxRequestDateFilterTextField: UITextField!
    @IBOutlet weak var requestNoTextField: UITextField!
    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var requestStateButton: UIButton!
    
    @IBOutlet weak var addRequestImageView: UIImageView!
    @IBOutlet weak var uploadRequestImageView: UIImageView!
    @IBOutlet weak var addRequestLabel: UILabel!
    @IBOutlet weak var uploadExcelLabel: UILabel!
    @IBOutlet weak var newRequestButton: UIButton!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        tableView.register(AllRequestTableViewCell.nib, forCellReuseIdentifier: AllRequestTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        initFilterUI()
        if #available(iOS 14.0, *) {
            initStateField()
        } else {
            // Fallback on earlier versions
        }
        addRequestImageView.hideOrShowViewByAppStoreReviewState()
        uploadRequestImageView.hideOrShowViewByAppStoreReviewState()
        addRequestLabel.hideOrShowViewByAppStoreReviewState()
        uploadExcelLabel.hideOrShowViewByAppStoreReviewState()
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
        minRequestDateFilterTextField.inputView = minDatePicker
        maxRequestDateFilterTextField.inputView = maxDatePicker
        minPriceTextField.keyboardType = .decimalPad
        maxPriceTextField.keyboardType = .decimalPad
        
        let lastWeekDate = NSCalendar.current.date(byAdding: .weekOfYear, value: -1, to: NSDate() as Date)
        
        minRequestDateFilterTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.firstDateSelected(_:)))
        maxRequestDateFilterTextField.keyboardToolbar.doneBarButton.setTarget(self,action: #selector(self.lastDateSelected(_:)))
        
    }
    
    @available(iOS 14.0, *)
    private func initStateField(){
        let requestReceived = UIAction(title: "Talebiniz Alındı") { [self] action in
            selectedRequestStateFilter = 2
            requestStatusFilterTextField.text = "Talebiniz Alındı"
        }
        let requestNotSent = UIAction(title: "Talebi Göndermediniz") { [self] action in
            selectedRequestStateFilter = 1
            requestStatusFilterTextField.text = "Talebi Göndermediniz"
        }
        let menu = UIMenu(title: "Talep Durumu", identifier: UIMenu.Identifier("menu"), options: .displayInline, children: [requestReceived, requestNotSent])
        requestStateButton.menu = menu
        requestStateButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func firstDateSelected(_ sender: Any) {
        minRequestDateFilterTextField.text = viewModel.fieldsDateFormatter.string(from: minDatePicker.date)
        minDateForEndpoint = viewModel.endpointDateFormatter.string(from: minDatePicker.date)
        //todo: update view model to get api call
    }
    
    @objc func lastDateSelected(_ sender: Any) {
        maxRequestDateFilterTextField.text = viewModel.fieldsDateFormatter.string(from: maxDatePicker.date)
        maxDateForEndpoint = viewModel.endpointDateFormatter.string(from: maxDatePicker.date)
        //todo: update view model to get api call
    }

    @IBAction func sendNewRequestButtonTapped(_ sender: UIButton) {
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
                    self.viewModel.getAllRequests()
                }
            }
        }    }
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.backButtonTapped()
    }
    
    @IBAction func filterCloseButtonClicked(_ sender: Any) {
        filterViewExpandedView.isHidden = true
        filterViewMinimizedView.isHidden = false
        minimizedFilterHeight.constant = 70
        expandedFilterHeight.constant = 0
    }
    
    @IBAction func filterRetryButtonClicked(_ sender: Any) {
        maxPriceTextField.text = ""
        minPriceTextField.text = ""
        requestNoTextField.text = ""
        maxRequestDateFilterTextField.text = ""
        minRequestDateFilterTextField.text = ""
        requestStatusFilterTextField.text = ""
        selectedRequestStateFilter = nil
        minDateForEndpoint = ""
        maxDateForEndpoint = ""
        isFilteredExpanded = false
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        filterViewExpandedView.isHidden = false
        filterViewMinimizedView.isHidden = true
        minimizedFilterHeight.constant = 0
        expandedFilterHeight.constant = 405
    }
    
    @IBAction func getExcelTemplateButtonClicked(_ sender: UIButton) {
        viewModel.getExcelTemplateToken()
    }
    
    @IBAction func excelUploadBtnClicked(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeSpreadsheet as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func getFilteredRequestsButtonClicked(_ sender: LGButton) {
        isFilteredExpanded = true
        let requestName: String? = requestNoTextField.text == "" ? nil : requestNoTextField.text
        let minDate: String? = minDateForEndpoint == "" ? nil : minDateForEndpoint
        let maxDate: String? = maxDateForEndpoint == "" ? nil : maxDateForEndpoint
        let stateCode: Int? = selectedRequestStateFilter
        let maxPrice: Double? = maxPriceTextField.text == "" ? nil : Double((maxPriceTextField.text!).replacingOccurrences(of: ",", with: "."))
        let minPrice: Double? = minPriceTextField.text == "" ? nil : Double((minPriceTextField.text!).replacingOccurrences(of: ",", with: "."))
        viewModel.getFilteredPurchaseRequest(name: requestName,
                                             minDate: minDate,
                                             maxDate: maxDate,
                                             maxPrice: maxPrice,
                                             minPrice: minPrice,
                                             stateCode: stateCode) {
        }
    }
}



//  MARK: - UIDocumentPickerDelegate Methods -
extension AllRequestViewController: UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
//        let data = NSData(contentsOf: myURL)
        viewModel.ImportPurchaseRequest(url: myURL)
    }
}



//    MARK: - TableView Methods -
extension AllRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllRequestTableViewCell") as! AllRequestTableViewCell
        if let requestData = sections[indexPath.row].requestData {
            cell.bind(requestData: requestData, isHidden: sections[indexPath.row].isHidden)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.row].isHidden.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
        selectedRequest = sections[indexPath.row].requestData
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == sections.count - 1 {
            if isFilteredExpanded {
                    let dataCount = sections.count
                    viewModel.getMoreFilteredPurchaseRequest { [self] in
                        sections = (viewModel.requestModel?.Data?.map({ data in
                            return AllRequestSection(requestData: data)
                        }))!
                        if sections.count > dataCount {
                            tableView.reloadData()
                        }
                    }
            } else {
                viewModel.fetchMoreRequest { [self] in
                    let dataCount = sections.count
                    sections = (viewModel.requestModel?.Data?.map({ data in
                        return AllRequestSection(requestData: data)
                    }))!
                    if sections.count > dataCount {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}


//    MARK: - AllRequestTableViewCellDelegate Methods -
extension AllRequestViewController: AllRequestTableViewCellDelegate {
    func deleteRequestClicked(id: Int?) {
        // delete request clicked
        viewModel.deletePurchaseRequest(id: id)
    }
    
    func editRequestClicked() {
        // edit request clicked
    }
    
    func requestDetailsClicked() {
        // detail ekranı aç
        let height = self.view.frame.height
        let width = self.view.frame.width
        if let selectedRequest = selectedRequest {
            requestDetailViewController = RequestDetailViewController.create(requestData: selectedRequest)
            requestDetailViewController?.delegate = self
            
            UIView.animate(withDuration: 0.4, delay: 0.01, options: .transitionCrossDissolve) { [self] in
                addSubView(subViewController: requestDetailViewController!, on: self.view, height: height)
            }
        }
    }
}

//    MARK: - NewRequestViewControllerDelegate Methods -
extension AllRequestViewController: NewRequestViewControllerDelegate {
    func backButtonTappedInNewRequest() {
        sendNewRequestButtonTapped(newRequestButton)
    }
}
//    MARK: - RequestDetailViewControllerDelegate Methods -
extension AllRequestViewController: RequestDetailViewControllerDelegate {
    func deleteButtonClicked(id: Int) {
        viewModel.deletePurchaseRequest(id: id)
        requestDetailViewController?.view.removeFromSuperview()
    }
    
    func backButtonTappedInRequestDetailDet() {
        requestDetailViewController?.view.removeFromSuperview()
    }
}


//    MARK: - AllRequestViewModelDelegate Methods -
extension AllRequestViewController: AllRequestViewModelDelegate {
    func ImportPurchaseRequestSuccess() {
        let vc: PopupViewController = PopupViewController.create(title: "Excel Başarılı Bir Şekilde Yüklenmiştir.",
                                                                 description: "")
        self.present(vc, animated: true)
        viewModel.getAllRequests()
    }
    
    func deletePurchaseRequestSuccess() {
        viewModel.getAllRequests()
    }
    
    func pageContentSuccess() {
        if let requestModel = viewModel.requestModel {
            if !(viewModel.requestModel?.Data!.isEmpty)! {
                sections = (viewModel.requestModel?.Data?.map({ data in
                    return AllRequestSection(requestData: data)
                }))!
                tableView.reloadData()
            } else {
                showErrorAlert(message: requestModel.Message ?? "generalErrorMessage".localized)
            }
        }
    }
    
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}



// MARK: - Creator
extension AllRequestViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "AllRequestViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore) -> AllRequestViewController {
        let vc: AllRequestViewController = AllRequestViewController.instantiateFromNib()
        let viewModel: AllRequestViewModel = AllRequestViewModel()
        vc.viewModel = viewModel
        vc.viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
