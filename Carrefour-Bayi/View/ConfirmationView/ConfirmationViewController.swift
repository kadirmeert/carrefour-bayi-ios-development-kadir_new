//
//  ConfirmationViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import UIKit
import PhoneNumberKit

class ConfirmationViewController: BaseViewController, UITextViewDelegate {
    // MARK: -Properties
    var viewModel: ConfirmationViewModel!
    
    let ratio = UIScreen.main.bounds.height / 812.0
    
    let screenMinX = UIScreen.main.bounds.minX
    let screenMinY = UIScreen.main.bounds.minY
    
    var darkBlueCircleDiameter: CGFloat = 0.0
    
    var whiteCircleDiameter: CGFloat = 0.0
    
    // MARK: -Views
    lazy var darkBlueCircle: UIView = {
        darkBlueCircleDiameter = 1226.0 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY),
                                        size: CGSize(width: 50, height: 50)))
        view.backgroundColor = .primaryDarkBlue
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var whiteCircle: UIView = {
        whiteCircleDiameter = 452.0 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY),
                                        size: CGSize(width: 50, height: 50)))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cityDisctrictStackView: UIStackView!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var confirmToOtpButton: BaseButton!
    
    private var cityPickerView: UIPickerView = UIPickerView()
    private var districtPickerView: UIPickerView = UIPickerView()
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
        initUI()
    }
    
    
    // MARK: -UI Methods
    private func initUI() {
        view.addSubview(darkBlueCircle)
        view.addSubview(whiteCircle)
        view.addSubview(logoImageView)
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
//        confirmToOtpButton.isEnabled = false
        setUpTextFields()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateToBot()
        }
        
      
    }
    
    private func setUpTextFields() {
        countryCodeTextField.isUserInteractionEnabled = false
        countryCodeTextField.keyboardType = .phonePad
        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .phonePad
//        phoneNumberTextField.maxDigits = 10
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(
            string: "phoneNumberMask".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldValueChanged), for: .editingDidBegin)
        
        districtView.isHidden = viewModel.confirmationModel?.isConfirmCityDistrict ?? true ? false : true
        cityView.isHidden = viewModel.confirmationModel?.isConfirmCityDistrict ?? true ? false : true
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        
        cityTextField.inputView = cityPickerView
        cityTextField.tintColor = .clear
        cityTextField.delegate = self
        cityTextField.attributedPlaceholder = NSAttributedString(
            string: "selection".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        
        districtTextField.inputView = districtPickerView
        districtTextField.tintColor = .clear
        districtTextField.delegate = self
        districtTextField.isUserInteractionEnabled = false
        districtTextField.attributedPlaceholder = NSAttributedString(
            string: "selection".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        cityTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.citySelected(_:)))
        districtTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.districtSelected(_:)))
    }
    
    private func animateToBot() {
        UIView.animate(withDuration: 1, animations: {
            self.darkBlueCircle.frame = CGRect(origin: CGPoint(x: -244.0 * self.ratio, y: -198.0 * self.ratio),
                                               size: CGSize(width: self.darkBlueCircleDiameter,
                                                            height: self.darkBlueCircleDiameter))
            self.darkBlueCircle.layer.cornerRadius = self.darkBlueCircle.frame.height / 2
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: -153 * self.ratio, y: -325 * self.ratio),
                                            size: CGSize(width: self.whiteCircleDiameter,
                                                         height: self.whiteCircleDiameter))
            self.whiteCircle.layer.cornerRadius = self.whiteCircle.frame.height / 2
            
//            self.phoneNumberTextField.becomeFirstResponder()
        })
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            self.darkBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY),
                                               size: CGSize(width: 50, height: 50))
            self.darkBlueCircle.layer.cornerRadius = self.darkBlueCircle.frame.height / 2
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY),
                                            size: CGSize(width: 50, height: 50))
            self.whiteCircle.layer.cornerRadius = self.whiteCircle.frame.height / 2
        } completion: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        checkAndShowErrorForEmptyFields()
        if let phoneNumber = phoneNumberTextField.text?.updatedPhoneNumber, phoneNumber.count == 10 {
            RepositoryProvider.tokenRepository.saveUserPhoneNumber(phoneNumber: phoneNumber)
            UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
            viewModel.performConfirmation(phoneNumber: phoneNumber)
        }
        
    }
    
    private func checkAndShowErrorForEmptyFields() {
        var errorMessage: String = ""
        let popupVC: PopupViewController?
        
        if viewModel.confirmationModel?.isConfirmCityDistrict == true {
            
            if phoneNumberTextField.text != "" {
                if cityTextField.text != "" {
                    if districtTextField.text != "" {
                    } else {
                        errorMessage = "İlçe Seçiniz!".localized
                    }
                } else {
                    errorMessage = "İl Seçiniz!".localized
                }
            } else {
                errorMessage = "Telefon Numarasını Doldurunuz!".localized
            }
            
        } else {
            if phoneNumberTextField.text == "" {
                errorMessage = "Telefon Numarasını Doldurunuz!".localized
            }
        }
        
        if errorMessage != "" {
            popupVC = PopupViewController.create(title: errorMessage, description: "")
            self.present(popupVC!, animated:  true)
        }
    }
    
    @objc
    func citySelected(_ sender: Any) {
        if let cities = viewModel.cities {
            districtTextField.isUserInteractionEnabled = true
            
            let selectedCity = cities[cityPickerView.selectedRow(inComponent: 0)]
            
            if cityTextField.text != selectedCity.Name {
                cityTextField.text = selectedCity.Name
                districtTextField.text = ""
                viewModel.getDistricts(city: selectedCity)
                if districtTextField.text == "" {
                    confirmToOtpButton.isEnabled = false
                } else {
                    confirmToOtpButton.isEnabled = true
                }            }
        }
  }
    
    @objc
    func districtSelected(_ sender: Any) {
        let selectedDistrict = viewModel.districts[districtPickerView.selectedRow(inComponent: 0)]
        
        districtTextField.text = selectedDistrict.Name
        viewModel.selectedDistrict = selectedDistrict
        if districtTextField.text == "" {
            confirmToOtpButton.isEnabled = false
        } else {
            confirmToOtpButton.isEnabled = true
        }
    }
    
    @objc
    func phoneNumberTextFieldValueChanged(_ sender: UITextField) {
        if phoneNumberTextField.text == "" {
            phoneNumberTextField.text = "(5"
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            if phoneNumberTextField.text != "" {
                phoneNumberTextField.text = String(phoneNumberTextField.text!.prefix(15))
            }
                
            if phoneNumberTextField.text == "" {
                phoneNumberTextField.text = "(5"
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            if phoneNumberTextField.text == "(5" {
                phoneNumberTextField.text = ""
                phoneNumberTextField.attributedPlaceholder = NSAttributedString(
                    string: "phoneNumberMask".localized,
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
                )
            }
        }
    }
}

// MARK:- UIPickerViewDelegate & UIPickerViewDataSource Methods
extension ConfirmationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 270
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            if let cities = viewModel.cities {
                return cities[row].Name
            } else { return "" }
        } else {
            return viewModel.districts[row].Name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView {
            if let cities = viewModel.cities {
                return cities.count
            } else { return 0 }
        } else {
            return viewModel.districts.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: -UITextFieldDelegate Methods
extension ConfirmationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.formatPhoneNumber(with: "(XXX) XXX XX XX")
        return false
    }
}

// MARK: -ConfirmationViewModelDelegate Methods
extension ConfirmationViewController: ConfirmationViewModelDelegate {
    func navigateToOtpPage(confirmationRequest: ConfirmationRequestDTO) {
        let vc: OTPCheckViewController = OTPCheckViewController.create(userName: "",
                                                                       phoneNumber: confirmationRequest.phoneNumber,
                                                                       codeId: confirmationRequest.CodeId,
                                                                       confirmationRequest: confirmationRequest)
        RepositoryProvider.tokenRepository.saveUserPhoneNumber(phoneNumber: confirmationRequest.phoneNumber)
        UserDefaults.standard.set(confirmationRequest.phoneNumber, forKey: "userPhoneNumber")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func contentFailed(errorMessage: String) {
        self.showErrorAlert(message: errorMessage)
    }
}

// MARK: - Creator
extension ConfirmationViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "ConfirmationViewController"
        }
    }
    
    class func create(confirmationModel: ConfirmationCreateModel) -> ConfirmationViewController {
        let vc: ConfirmationViewController = ConfirmationViewController.instantiateFromNib()
        let viewModel: ConfirmationViewModel = ConfirmationViewModel(confirmationModel: confirmationModel)
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
