
//
//  AddNewCreditCartTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 21.12.2022.
//

import UIKit
import LGButton


protocol AddNewCreditCardTableViewCellDelegate {
    func saveCreditCardClicked(cardModel: PaymentCardInfoModel, mfsCheckBox: MfsCheckbox)
    func selectButtonToggledInAddNewCreditCardSection()
    func directCompletePayment(mfsCard: MfsCard, mfsTextField: MfsTextField, mfsCVV: MfsTextField, mfsCheckBox: MfsCheckbox)
    func smsVerifyButtonTapped(smsTextField: MfsTextField)
    func termsOfMasterpassLabelTapped()
}


struct PaymentCardInfoModel {
    var cardNumber: String = ""
    var cardName: String = ""
    var month: String = ""
    var year: String = ""
    var cvv: String = ""
    var savedCardName: String = ""
}


class AddNewCreditCardTableViewCell: UITableViewCell, UITextFieldDelegate, MfsTextFieldDelegate {
    
    var delegate: AddNewCreditCardTableViewCellDelegate?
    var cardModel = PaymentCardInfoModel()
    //    MARK: - views
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topLineView: UIView!
    
    @IBOutlet weak var selectNewCardButton: UIButton!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var lastMonthTextField: UITextField!
    @IBOutlet weak var lastYearTextField: UITextField!
    @IBOutlet weak var cvvTextField: MfsTextField!
    
    @IBOutlet weak var cardNumberTextField: MfsTextField!
    
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!

    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    
    @IBOutlet weak var saveCardCheckStackView: UIStackView!
    @IBOutlet weak var savedCardNameStackView: UIStackView!
    @IBOutlet weak var savedCardNameTextField: UITextField!
    @IBOutlet weak var SMSActivationStackView: UIStackView!
    @IBOutlet weak var SMSActivationButton: LGButton!
    @IBOutlet weak var SMSActivationTextField: MfsTextField!
    @IBOutlet weak var saveAndContinueButton: LGButton!
    
    var checkBox = MfsCheckbox()
    var mfsCard = MfsCard()
    private let yearDatePicker: UIPickerView = UIPickerView()
    private let monthDatePicker: UIPickerView = UIPickerView()
    
    private var yearsAsString = [String]()
    private var monthsAsString = [String]()
    private let yearInterval = 70
    
    
    func bind(cardModel: PaymentCardInfoModel, isSelectedNewCard: Bool,
              isSaveCreditCard: Bool, isSMSExpanded: Bool, isRoundCorner: Bool) {
        if isRoundCorner {
            baseView.layer.cornerRadius = 10
            topLineView.alpha = 0
        } else {
            baseView.layer.cornerRadius = 0
            topLineView.alpha = 1
        }

        self.cardModel = cardModel
        setCardInfos()
        
        selectNewCardButton.isSelected = isSelectedNewCard
        savedCardNameStackView.isUserInteractionEnabled = isSaveCreditCard
        savedCardNameStackView.alpha = (!isSaveCreditCard) ? 0.0 : 1.0
        SMSActivationStackView.isHidden = !isSMSExpanded
        selectNewCardButton.setImage(UIImage(systemName: "record.circle"), for: .selected)
        selectNewCardButton.setImage(UIImage(systemName: "circle"), for: .normal)
       
        setDelegates()
        setupMfsTextFields()
        setupMfsCheckBox()
        setupTermsLabel()
        initDatePickers()
    }

    
    private func setDelegates() {
        cardNameTextField.delegate = self
        lastMonthTextField.delegate = self
        lastYearTextField.delegate = self
        cardNumberTextField.delegate = self
        savedCardNameTextField.delegate = self
        cvvTextField.delegate = self
        cardNameTextField.autocapitalizationType = .allCharacters
        SMSActivationTextField.delegate = self
    }
    
    
    private func setupMfsTextFields() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let t = MfsTextField()
            
            self.cardNumberTextField.mfsDelegate = self
            self.cardNumberTextField.setType(1)
            self.cardNumberTextField.maxLength = 20
            self.cardNumberTextField.keyboardType = .numberPad
            
            self.cvvTextField.mfsDelegate = self
            self.cvvTextField.setType(3)
            self.cvvTextField.maxLength = 4
            self.cvvTextField.keyboardType = .numberPad
            
            self.SMSActivationTextField.mfsDelegate = self
            self.SMSActivationTextField.setType(2)
            self.SMSActivationTextField.keyboardType = .numberPad
        }
    }
    
    
    private func setupMfsCheckBox() {
        checkBox.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkBox.center = saveCardButton.center
        saveCardButton.addSubview(checkBox)
        checkBox.addTarget(self, action: #selector(saveCardCheckboxClicked(_ :)), for: .valueChanged)
    }
    
    
    private func setupTermsLabel() {
        termsLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnTermsLabel(_ :)))
        tapGesture.numberOfTapsRequired = 1
        termsLabel.addGestureRecognizer(tapGesture)
        let attributedString = NSMutableAttributedString(string: termsLabel.text!)
        attributedString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue],
                                       range: NSRange(location: 65, length: 29))
        termsLabel.attributedText = attributedString
    }
    
    
    private func initDatePickers() {
        initMonthAndYearArrays()
        yearDatePicker.delegate = self
        monthDatePicker.delegate = self
        
        lastMonthTextField.inputView = monthDatePicker
        lastYearTextField.inputView = yearDatePicker
    }
    
    
    private func initMonthAndYearArrays() {
        monthsAsString = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        let currentYear = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year
        
        guard let currentYear = currentYear else { return }
        
        for year in currentYear...(currentYear + yearInterval) {
            yearsAsString.append("\(year)")
        }
    }
    
    

    
    
    private func setCardInfos() {
        cardNameTextField.text = self.cardModel.cardName
        lastMonthTextField.text = self.cardModel.month
        lastYearTextField.text = self.cardModel.year
        savedCardNameTextField.text = self.cardModel.savedCardName
        
        nameField.text = self.cardModel.cardName
        monthField.text = self.cardModel.month
        yearField.text = self.cardModel.year
        
        mfsCard.expireYear = self.cardModel.year
        mfsCard.expireMonth = self.cardModel.month
    }
    
    
    
    @objc
    private func tappedOnTermsLabel(_ gesture: UITapGestureRecognizer) {
        self.delegate?.termsOfMasterpassLabelTapped()
    }
    
    
    
    @objc
    private func saveCardCheckboxClicked(_ sender: MfsCheckbox) {
        savedCardNameStackView.isUserInteractionEnabled.toggle()
        savedCardNameStackView.alpha = (!savedCardNameStackView.isUserInteractionEnabled) ? 0.0 : 1.0
        delegate?.saveCreditCardClicked(cardModel: self.cardModel, mfsCheckBox: checkBox)
    }
    
    
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        delegate?.selectButtonToggledInAddNewCreditCardSection()
    }
    
    
    @IBAction func cardNameTextFieldEditingDidChange(_ sender: UITextField) {
        nameField.text = sender.text ?? ""
        cardModel.cardName = sender.text ?? ""
        mfsCard.cardHolderName = sender.text ?? ""
    }
    
    
    @IBAction func savedCardNameTextFieldEditingDidChange(_ sender: UITextField) {
        mfsCard.cardName = sender.text
    }
    
    
    @IBAction func verifySMSCodeButtonClicked(_ sender: Any) {
        self.delegate?.smsVerifyButtonTapped(smsTextField: SMSActivationTextField)
    }
    
    
    @IBAction func completePaymentButtonClicked(_ sender: Any) {
        self.mfsCard.expireYear = String(lastYearTextField.text?.suffix(2) ?? "")
        delegate?.directCompletePayment(mfsCard: self.mfsCard, mfsTextField: self.cardNumberTextField,
                                        mfsCVV: self.cvvTextField, mfsCheckBox: checkBox)
    }
}




//    MARK: - UIPicker view delegate
extension AddNewCreditCardTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerView == monthDatePicker) ? 12 : yearInterval
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthDatePicker {
            return monthsAsString[row]
        } else {
            return yearsAsString[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthDatePicker {
            lastMonthTextField.text = monthsAsString[row]
            monthField.text = monthsAsString[row]
            cardModel.month = monthsAsString[row]
            mfsCard.expireMonth = monthsAsString[row]
        } else {
            lastYearTextField.text = yearsAsString[row]
            yearField.text = yearsAsString[row]
            cardModel.year = yearsAsString[row]
            mfsCard.expireYear = yearsAsString[row]
        }
    }
}








//    MARK: - MfsTextField methods
extension AddNewCreditCardTableViewCell {
    func mfsTextFieldGetFirst6Chars(_ first6Chars: String!) {
        let first4Chars = first6Chars.prefix(4)
        let last2Chars = first6Chars.suffix(2)
        cardNumberField.text = "\(first4Chars)    \(last2Chars)**    ****    ****"
    }
    
    func mfsTextFieldDidClear(_ typeId: Int) {
        cardNumberField.text = ""
    }
}
