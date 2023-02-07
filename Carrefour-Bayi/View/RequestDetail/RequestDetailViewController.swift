//
//  RequestDetailViewController.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 12.11.2022.
//

import UIKit

protocol RequestDetailViewControllerDelegate {
    func backButtonTappedInRequestDetailDet()
    func deleteButtonClicked(id: Int)
}

class RequestDetailViewController: BaseViewController {

    //    MARK: - Properties -
    var viewModel: RequestDetailViewModel!
    var delegate: RequestDetailViewControllerDelegate?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    var id: Int?
    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yellowStateView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var requestNameLabel: UILabel!
    @IBOutlet weak var requestDateLabel: UILabel!
    @IBOutlet weak var requestPriceLabel: UILabel!
    @IBOutlet weak var requestStateLabel: UILabel!
    @IBOutlet weak var deleteRequestView: UIView!
    @IBOutlet weak var editRequestView: UIView!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        tableView.register(OrderDetailTableViewCell.nib, forCellReuseIdentifier: OrderDetailTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        yellowStateView.layer.cornerRadius = yellowStateView.frame.width / 2
        stateView.layer.borderColor = UIColor.primaryLightBlue.cgColor
        stateView.layer.borderWidth = 1
        switch viewModel.requestData?.StateCode {
            case 0:
                yellowStateView.backgroundColor = .primaryRed
          
            case 1:
                yellowStateView.backgroundColor = .primaryYellow
          
            case 2:
                yellowStateView.backgroundColor = .primaryDarkBlue
                editRequestView.isHidden = true
                deleteRequestView.isHidden = true
            default:
                break
        }
        setLabelTexts()
        editRequestView.hideOrShowViewByAppStoreReviewState()
        deleteRequestView.hideOrShowViewByAppStoreReviewState()
    }
    
    private func setLabelTexts() {
        let data = viewModel.requestData
        requestStateLabel.text = data?.StateCodeValue
        requestIdLabel.text = "ID  \(data?.Id ?? 0)"
        requestNameLabel.text = "\(data?.Name ?? "-")"
        requestDateLabel.text = "\(data?.RequestDate ?? "-")"
        requestPriceLabel.text = "\((data?.TotalPrice ?? 0.0).formattedCurrency) ₺"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        if let recordDate = dateFormatter.date(from: data!.RequestDate!){
            let dateText = dateFormatter1.string(from: recordDate)
            requestDateLabel.text = dateText
        }
        self.id = data?.Id ?? 0
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        delegate?.backButtonTappedInRequestDetailDet()
    }
    
    
    @IBAction func editButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        self.delegate?.deleteButtonClicked(id: self.id ?? 0)
    }
}

//    MARK: - TableView Methods -
extension RequestDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requestDetailModel?.Data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
        if let requestDetailData = viewModel.requestDetailModel?.Data {
            cell.bindRequestDetail(requestDetailData: requestDetailData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

//    MARK: - RequestDetailViewModelDelegate Methods -
extension RequestDetailViewController: RequestDetailViewModelDelegate {
    func deletePurchaseRequestSuccess() {
         
    }
    
    func pageContentSuccess() {
        tableView.reloadData()
    }
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}
// MARK: - Creator
extension RequestDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "RequestDetailViewController"
        }
    }
    
    class func create(requestData: PurchaseRequestData) -> RequestDetailViewController {
        let vc: RequestDetailViewController = RequestDetailViewController.instantiateFromNib()
        let viewModel: RequestDetailViewModel = RequestDetailViewModel()
        vc.viewModel = viewModel
        vc.viewModel.requestData = requestData
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
