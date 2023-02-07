//
//  RegionalDirectorateViewController.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 13.11.2022.
//

import UIKit
import MobileCoreServices
import LGButton

class AllRegionalManagerSection {
    var regionalManagerData: RegionalManagerData?
    var isHidden: Bool = true
    
    init(regionalManagerData: RegionalManagerData? = nil, isHidden: Bool = true) {
        self.regionalManagerData = regionalManagerData
        self.isHidden = isHidden
    }
}


protocol RegionalDirectorateViewControllerDelegate: AnyObject {
    func regionalDirectoriesBackButtonTapped()
}

class RegionalDirectorateViewController: BaseViewController {
    //    MARK: - Properties -
    var viewModel: RegionalDirectorateViewModel!
    weak var delegate: RegionalDirectorateViewControllerDelegate?
    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterViewExpandedView: UIView!
    @IBOutlet weak var filterViewMinimizedView: UIView!
    @IBOutlet weak var expandedFilterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minimizedFilterHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sapTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        RegionalDirectorateTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initFilterUI()
    }
    
    private func initFilterUI(){
        filterViewExpandedView.isHidden = true
        filterViewMinimizedView.isHidden = false
        expandedFilterHeightConstraint.constant = 0
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        filterViewExpandedView.isHidden = false
        filterViewMinimizedView.isHidden = true
        expandedFilterHeightConstraint.constant = 304
        minimizedFilterHeightConstraint.constant = 0
    }
    
    @IBAction func filterRetryButtonClicked(_ sender: Any) {
        emailTextField.text = ""
        sapTextField.text = ""
//        nameSurnameTextField.text = ""
        storeNameTextField.text = ""
    }
    
    
    @IBAction func filterCloseButtonClicked(_ sender: Any) {
        filterViewExpandedView.isHidden = true
        filterViewMinimizedView.isHidden = false
        expandedFilterHeightConstraint.constant = 0
        minimizedFilterHeightConstraint.constant = 70
    }
    
    
    @IBAction func getFilteredManagersButtonClicked(_ sender: LGButton) {
        let emailAddress: String? = emailTextField.text == "" ? nil : emailTextField.text
        let sapCode: String? = sapTextField.text == "" ? nil : sapTextField.text
        let storeName: String? = storeNameTextField.text == "" ? nil : storeNameTextField.text
        viewModel.getFilteredRegionalManagers(emailAdress: emailAddress, SAP: sapCode, storeName: storeName)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        delegate?.regionalDirectoriesBackButtonTapped()
    }
    
    
    @IBAction func exportExcelClicked(_ sender: Any) {
        viewModel.getTokenForRegionalManagersDownloadExcel()
    }
    
    @IBAction func excelUploadClicked(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeSpreadsheet as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func fileDownloadClicked(_ sender: Any) {
        viewModel.getTokenForDownloadExcelTemplate()
    }
    
}

//  MARK: - UIDocumentPickerDelegate Methods -
extension RegionalDirectorateViewController: UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
//        let data = NSData(contentsOf: myURL)
        viewModel.importRegionalManagers(url: myURL)
    }
}

//    MARK: - TableView Methods -
extension RegionalDirectorateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionalDirectorateTableViewCell") as! RegionalDirectorateTableViewCell
        
        if let regionalData = viewModel.sections[indexPath.row].regionalManagerData {
            cell.bind(managerData: regionalData, isHidden: viewModel.sections[indexPath.row].isHidden)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.sections[indexPath.row].isHidden.toggle()
        viewModel.selectedManager = viewModel.sections[indexPath.row].regionalManagerData
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//    MARK: - RegionalDirectorateTableViewCellDelegate Methods -
extension RegionalDirectorateViewController: RegionalDirectorateTableViewCellDelegate{
    func deleteClicked() {
        if let selectedManager = viewModel.selectedManager, let id = selectedManager.Id,
           let name = selectedManager.Username, let surname = selectedManager.Surname, let sapCode = selectedManager.SAPCode {
            let alert = UIAlertController(title: "",
                                          message: "\(name) \(surname) \(sapCode) Bölge Müdürünü Silmek İstediğinizden Emin Misiniz?",
                                          preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { action in
                self.viewModel.deleteRegionalManager(regionalManagerId: id)
            }
            let cancelAction = UIAlertAction(title: "İptal", style: .default)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
}


// MARK: - RegionalDirectorateViewModelDelegate
extension RegionalDirectorateViewController: RegionalDirectorateViewModelDelegate{
    func pageContentSuccess() {
        self.tableView.reloadData()
    }
    
    func pageContentFailed(message: String) {
        self.showErrorAlert(message: message)
    }
    
    func managerTransactionSuccess(message: String) {
        self.showAlert(message: message) {
            self.viewModel.getRegionalManagers()
        }
    }
}


// MARK: - Creator
extension RegionalDirectorateViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "RegionalDirectorateViewController"
        }
    }
    
    class func create() -> RegionalDirectorateViewController {
        let vc: RegionalDirectorateViewController = RegionalDirectorateViewController.instantiateFromNib()
        let viewModel: RegionalDirectorateViewModel = RegionalDirectorateViewModel()
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
