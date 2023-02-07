//
//  PaymentViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 19.12.2022.
//


import UIKit



protocol PaymentViewControllerDelegate {
    func backButtonClickedInPayment()
}

class PaymentViewController: BaseViewController  {
    
    //    MARK: - Properties-
    var viewModel: PaymentViewModel!
    var delegate: PaymentViewControllerDelegate?
    
    //    MARK: - Views-
    @IBOutlet weak var tableView: UITableView!
    
    var isSaveCreditCard: Bool = false
    var isSMSExpanded: Bool = false
    var enteredPaymentAmount: String?
    var isSelectedRegisteredCard: Bool = false
    
    var cardModel = PaymentCardInfoModel()
    var mfsWebView3D = MfsWebView()
    var checkBox: MfsCheckbox?
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        PaymentAmountTableViewCell.registerSelf(tableView: tableView)
        RegisteredCardTableViewCell.registerSelf(tableView: tableView)
        AddNewCreditCardTableViewCell.registerSelf(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        mfsWebView3D.delegateMfsWebView = self
        self.view.addSubview(mfsWebView3D)
        mfsWebView3D.frame = self.view.frame
        mfsWebView3D.isHidden = true
        mfsWebView3D.alpha = 0
    }
}




// MARK: -UITableViewDelegate & UITableViewDataSource
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((viewModel.registeredCards == nil) ? 2 : 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.registeredCards == nil {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentAmountTableViewCell") as! PaymentAmountTableViewCell
                cell.bind()
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCreditCardTableViewCell") as! AddNewCreditCardTableViewCell
                cell.bind(cardModel: self.cardModel, isSelectedNewCard: !isSelectedRegisteredCard,
                          isSaveCreditCard: isSaveCreditCard, isSMSExpanded: isSMSExpanded, isRoundCorner: true)
                cell.delegate = self
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentAmountTableViewCell") as! PaymentAmountTableViewCell
                cell.bind()
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredCardTableViewCell") as! RegisteredCardTableViewCell
                cell.bind(isSelectedRegisteredCard: isSelectedRegisteredCard, registeredCards: viewModel.registeredCards)
                cell.delegate = self
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCreditCardTableViewCell") as! AddNewCreditCardTableViewCell
                cell.bind(cardModel: self.cardModel, isSelectedNewCard: !isSelectedRegisteredCard,
                          isSaveCreditCard: isSaveCreditCard, isSMSExpanded: isSMSExpanded, isRoundCorner: false)
                cell.delegate = self
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}





//    MARK: - Mfs WebView Delegate
extension PaymentViewController: MfsWebViewCallback {
    func webViewStartLoading(_ webView: WKWebView!) {
        mfsWebView3D.isHidden = false
        mfsWebView3D.alpha = 1
    }
    func webViewFinishLoading(_ webView: WKWebView!) { }
}




//    MARK: - Payment ViewModelDelegate
extension PaymentViewController: PaymentViewModelDelegate {    
    func getCardsSuccess() {
        if viewModel.registeredCards != nil {
            isSelectedRegisteredCard = true
            tableView.reloadData()
        }
    }
    
    func validateTransaction3DWillFinish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mfsWebView3D.alpha = 0
            self.mfsWebView3D.isHidden = true
        }
        
    }
    
    func callValidateTransaction3D(mfsResponse: MfsResponse) {
        self.viewModel.validateTransaction3D(mfsWebView: mfsWebView3D, mfsResponse: mfsResponse)
    }
    
    func callValidateTransaction() {
        isSMSExpanded = true
        let index = (viewModel.registeredCards == nil) ? 1 : 2
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func processCompleted(message: String) {
        self.showAlert(message: message)
    }
    
    func paymentSuccessfullyCompleted() {
        let paymentCompletedPopUpViewController: PaymentCompletedPopUpViewController = PaymentCompletedPopUpViewController.create()
        self.present(paymentCompletedPopUpViewController, animated: true)
    }
    
    func pageContentFailed(message: String) {
        self.showAlert(message: message)
    }
    
    func reloadPage() {
        self.reloadViewFromNib()
    }
}




//    MARK: - PaymentAmount TableViewCellDelegate
extension PaymentViewController: PaymentAmountTableViewCellDelegate {
    func paymentAmountChanged(paymentAmount: String) {
        self.enteredPaymentAmount = paymentAmount
    }
}



//    MARK: - RegisteredCard TableViewCellDelegate
extension PaymentViewController: RegisteredCardTableViewCellDelegate {
    func deleteRegisteredCardClicked(cardName: String) {
        viewModel.deleteCard(cardName: cardName)
    }
    
    func selectButtonToggledInRegisteredCardsSection() {
        if isSelectedRegisteredCard == false {
            isSelectedRegisteredCard.toggle()
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0),
                                      IndexPath(row: 2, section: 0)], with: .fade)
        }
    }
    
    func registeredCardClickedForPayment(cardName: String) {
        if let enteredPaymentAmount, Int(enteredPaymentAmount) != 0  {
            viewModel.insertPurchase(cardName: cardName, amount: enteredPaymentAmount)
        } else {
            self.showAlert(message: "Lütfen ödeme yaptığınız miktarı kontrol edip tekrar deneyiniz!") {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}




//    MARK: - NewCreditCard TableViewCellDelegate
extension PaymentViewController: AddNewCreditCardTableViewCellDelegate {
    func directCompletePayment(mfsCard: MfsCard, mfsTextField: MfsTextField, mfsCVV: MfsTextField, mfsCheckBox: MfsCheckbox) {
        if let enteredPaymentAmount {
            if mfsCheckBox.checked {
                viewModel.currentCard = mfsCard
                let expirationDate = mfsCard.expireMonth + "20" + mfsCard.expireYear
                viewModel.insertRegisterPurchase(expirationDate: expirationDate, amount: enteredPaymentAmount, mfsCard: mfsCard,
                                                 mfsTextField: mfsTextField, mfsCVV: mfsCVV, mfsCheckBox: mfsCheckBox)
            } else {
                viewModel.currentCard = mfsCard
                let expirationDate = mfsCard.expireMonth + "20" + mfsCard.expireYear
                viewModel.insertDirectPurchase(expirationDate: expirationDate, amount: enteredPaymentAmount, mfsCard: mfsCard,
                                               mfsTextField: mfsTextField, mfsCVV: mfsCVV)
            }
        } else {
            self.showAlert(message: "Lütfen ödeme yaptığınız miktarı kontrol edip tekrar deneyiniz!") {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func saveCreditCardClicked(cardModel: PaymentCardInfoModel, mfsCheckBox: MfsCheckbox) {
        self.cardModel = cardModel
        self.checkBox = mfsCheckBox
    }
    
    
    func selectButtonToggledInAddNewCreditCardSection() {
        if isSelectedRegisteredCard == true {
            isSelectedRegisteredCard.toggle()
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0),
                                      IndexPath(row: 2, section: 0)], with: .fade)
        }
    }
    
    func smsVerifyButtonTapped(smsTextField: MfsTextField) {
            viewModel.validateTransaction(mfsTextField: smsTextField)
    }
    
    func termsOfMasterpassLabelTapped() {
        let rejectAction = UIAlertAction(title: "Hayır", style: .default)
        let acceptAction = UIAlertAction(title: "Kabul Ediyorum", style: .default) { _ in
            // send call to addNewCreditCard cell and checked checkbox
        }
        self.showAlert(title: "Masterpass Kullanım Şartları", message: Constant.termsText, actions: [rejectAction, acceptAction])
        self.showAlert(message: Constant.termsText)
    }
}




//    MARK: - Creator
extension PaymentViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "PaymentViewController"
        }
    }
    
    class func create(currentCompanyAndStore: CurrentCompanyAndStore) -> PaymentViewController {
        let vc: PaymentViewController = PaymentViewController.instantiateFromNib()
        let viewModel: PaymentViewModel = PaymentViewModel()
        viewModel.currentCompanyAndStore = currentCompanyAndStore
        vc.viewModel = viewModel
        viewModel.delegate = vc
        return vc
    }
}

