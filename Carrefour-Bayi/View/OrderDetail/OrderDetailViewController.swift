//
//  OrderDetailViewController.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 11.11.2022.
//

import UIKit

protocol OrderDetailViewControllerDelegate {
    func backButtonTappedInOrderDetaild()
}

class OrderDetailViewController: BaseViewController {
    
    //    MARK: - Properties -
    var viewModel: OrderDetailViewModel!
    var delegate: OrderDetailViewControllerDelegate?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    //    MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yellowStateView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    
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
        switch viewModel.orderData?.StateCode {
            case 0:
                yellowStateView.backgroundColor = .primaryYellow
            case 1:
                yellowStateView.backgroundColor = .primaryDarkBlue
            case 2:
                yellowStateView.backgroundColor = .primaryRed
            default:
                break
        }
        setLabelTexts()
    }
    
    private func setLabelTexts() {
        let data = viewModel.orderData
        orderIdLabel.text = "ID  \(data?.Id ?? 0)"
        orderNameLabel.text = "\(data?.Name ?? "-")"
        orderDateLabel.text = "\(data?.OrderDate ?? "-")"
        orderPriceLabel.text = "\((data?.TotalPrice ?? 0.0).formattedCurrency) ₺"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        if let recordDate = dateFormatter.date(from: data!.OrderDate){
            let dateText = dateFormatter1.string(from: recordDate)
            orderDateLabel.text = dateText
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        delegate?.backButtonTappedInOrderDetaild()
    }
}

//    MARK: - TableView Methods -
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderDetailModel?.OrderDetail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
        if let orderDetailData = viewModel.orderDetailModel?.OrderDetail {
            cell.bindOrder(orderDetailData: orderDetailData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//    MARK: - OrderDetailViewModelDelegate Methods -
extension OrderDetailViewController: OrderDetailViewModelDelegate {
    func pageContentSuccess() {
        tableView.reloadData()
    }
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}



// MARK: - Creator
extension OrderDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "OrderDetailViewController"
        }
    }
    
    class func create(orderData: OrderData) -> OrderDetailViewController {
        let vc: OrderDetailViewController = OrderDetailViewController.instantiateFromNib()
        let viewModel: OrderDetailViewModel = OrderDetailViewModel()
        vc.viewModel = viewModel
        vc.viewModel.orderData = orderData
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
