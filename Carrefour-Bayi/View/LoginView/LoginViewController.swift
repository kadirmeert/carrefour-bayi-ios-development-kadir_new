//
//  LoginViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 26.07.2022.
//

import UIKit
import CryptoSwift
import WebKit

class LoginViewController: BaseViewController {
    // MARK: - Properties
    var viewModel: LoginViewModel!
    
    let ratio = UIScreen.main.bounds.height / 812.0
    
    var redCircleDiameter: CGFloat = 0.0
    var redCircleX: CGFloat = 0.0
    var redCircleY: CGFloat = 0.0
    
    var darkBlueCircleDiameter: CGFloat = 0.0
    var darkBlueCircleX: CGFloat = 0.0
    var darkBlueCircleY: CGFloat = 0.0
    
    var lightBlueCircleDiameter: CGFloat = 0.0
    var lightBlueCircleX: CGFloat = 0.0
    var lightBlueCircleY: CGFloat = 0.0
    
    var whiteCircleDiameter: CGFloat = 0.0
    var whiteCircleX: CGFloat = 0.0
    var whiteCircleY: CGFloat = 0.0
    
    var keyboardHeight: CGFloat = 0
    
    var isKeyboardAppeared: Bool = false
    
    
    // MARK: - Views
    lazy var redCircle: UIView = {
        redCircleDiameter = 784.0 * ratio
        
        redCircleX = -182.0 * ratio
        redCircleY = 246.0 * ratio
        
        let redCircle = UIView(frame: CGRect(origin: CGPoint(x: redCircleX, y: redCircleY), size: CGSize(width: redCircleDiameter, height: redCircleDiameter)))
        redCircle.backgroundColor = .primaryRed
        redCircle.layer.cornerRadius = redCircle.frame.height / 2
        return redCircle
    }()
    
    lazy var darkBlueCircle: UIView = {
        if UIDevice().userInterfaceIdiom == .pad {
            darkBlueCircleDiameter = 884.0 * ratio
        } else {
            darkBlueCircleDiameter = 784.0 * ratio
        }
        
        darkBlueCircleX = -282.0 * ratio
        darkBlueCircleY = -67.0 * ratio
        
        let darkBlueCircle = UIView(frame: CGRect(origin: CGPoint(x: darkBlueCircleX, y: darkBlueCircleY), size: CGSize(width: darkBlueCircleDiameter, height: darkBlueCircleDiameter)))
        darkBlueCircle.backgroundColor = .primaryDarkBlue
        darkBlueCircle.layer.cornerRadius = darkBlueCircle.frame.height / 2
        return darkBlueCircle
    }()
    
    lazy var lightBlueCircle: UIView = {
        lightBlueCircleDiameter = 613.0 * ratio
        
        lightBlueCircleX = -27.0 * ratio
        lightBlueCircleY = -258.0 * ratio
        
        let lightBlueCircle = UIView(frame: CGRect(origin: CGPoint(x: lightBlueCircleX, y: lightBlueCircleY), size: CGSize(width: lightBlueCircleDiameter, height: lightBlueCircleDiameter)))
        lightBlueCircle.backgroundColor = UIColor.primaryLightBlue
        lightBlueCircle.layer.cornerRadius = lightBlueCircle.frame.height / 2
        return lightBlueCircle
    }()
    
    lazy var whiteCircle: UIView = {
        if UIDevice().userInterfaceIdiom == .pad {
            whiteCircleDiameter = 402.0 * ratio
        } else {
            whiteCircleDiameter = 442.0 * ratio
        }
        
        whiteCircleX = -116.0 * ratio
        whiteCircleY = -290.0 * ratio
        
        let whiteCircle = UIView(frame: CGRect(origin: CGPoint(x: whiteCircleX, y: whiteCircleY), size: CGSize(width: whiteCircleDiameter, height: whiteCircleDiameter)))
        whiteCircle.backgroundColor = UIColor.white
        whiteCircle.layer.cornerRadius = whiteCircle.frame.height / 2
        return whiteCircle
    }()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var headerTextsStackView: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var userInfoStackView: UIStackView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hidePasswordButton: UIButton!
    
    
    @IBOutlet weak var loginButton: BaseButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var consultButton: UIButton!
    
    //    @IBOutlet weak var forgotPasswordStackView: UIStackView!
    //    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var userInfoStackViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI Methods
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        hidePasswordButton.setTitle("", for: .normal)
        addViews()
        setUpCloseButton()
        setUpTextFields()
        handleLoginButton(isButtonActive: false, isAlphaActive: true)
        animateToBottom()
        
        //    MARK: - Will Remove -
        
#if DEBUG
        
//        userNameTextField.text = "sabri.basoglu@bilmsoft.com"
//        passwordTextField.text = "37Ez97737c"
        
//
        
        userNameTextField.text = "mert.yildiz@bilmsoft.com"
        passwordTextField.text = "BilmSoft2200"
        
        //        userNameTextField.text = "emre.gunay@carrefoursa.com"
        //        passwordTextField.text = "Yun.123321"
        
        //        userNameTextField.text = "yunus.unay@carrefoursa.com"
        //        passwordTextField.text = "Yun.123321"
        
        //        userNameTextField.text = "taha.malaldir@bilmsoft.com"
        //        passwordTextField.text = "Tm*112113"
#endif
        
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        animateToBottom()
    }
    
    private func animateToTop() {
        isKeyboardAppeared = true
        
        UIView.transition(with: headerTextsStackView, duration: 1.25, options: .curveEaseOut, animations: {
            self.headerTextsStackView.alpha = 0
        })
        
        UIView.transition(with: closeButton, duration: 1.25, options: .curveEaseIn, animations: {
            self.closeButton.alpha = 1
            self.closeButton.isUserInteractionEnabled = true
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
            self.redCircle.frame = CGRect(origin: CGPoint(x: -56.0 * self.ratio, y: 239.0 * self.ratio), size: CGSize(width: self.redCircleDiameter, height: self.redCircleDiameter))
            
            self.darkBlueCircle.frame = CGRect(origin: CGPoint(x: -221.0 * self.ratio, y: -197.0 * self.ratio), size: CGSize(width: self.darkBlueCircleDiameter, height: self.darkBlueCircleDiameter))
            
            self.lightBlueCircle.frame = CGRect(origin: CGPoint(x: -244.0 * self.ratio, y: -527 * self.ratio), size: CGSize(width: self.lightBlueCircleDiameter, height: self.lightBlueCircleDiameter))
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: -131 * self.ratio, y: -298 * self.ratio), size: CGSize(width: self.whiteCircleDiameter, height: self.whiteCircleDiameter))
            
            self.userInfoStackViewBottomConstraint.constant = self.keyboardHeight - 60
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateToBottom() {
        isKeyboardAppeared = false
        self.view.endEditing(true)
        
        UIView.transition(with: headerTextsStackView, duration: 1.25, options: .curveEaseIn, animations: {
            self.headerTextsStackView.alpha = 1
        })
        
        UIView.transition(with: closeButton, duration: 1.25, options: .curveEaseOut, animations: {
            self.closeButton.alpha = 0
            self.closeButton.isUserInteractionEnabled = false
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            
            self.redCircle.frame = CGRect(origin: CGPoint(x: -182.0 * self.ratio, y: 246.0 * self.ratio), size: CGSize(width: self.redCircleDiameter, height: self.redCircleDiameter))
            
            self.darkBlueCircle.frame = CGRect(origin: CGPoint(x: -282.0 * self.ratio, y: -67.0 * self.ratio), size: CGSize(width: self.darkBlueCircleDiameter, height: self.darkBlueCircleDiameter))
            
            self.lightBlueCircle.frame = CGRect(origin: CGPoint(x: -27.0 * self.ratio, y: -258.0 * self.ratio), size: CGSize(width: self.lightBlueCircleDiameter, height: self.lightBlueCircleDiameter))
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: -96.0 * self.ratio, y: -290.0 * self.ratio), size: CGSize(width: self.whiteCircleDiameter, height: self.whiteCircleDiameter))
            
            self.userInfoStackViewBottomConstraint.constant = 70
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func setUpTextFields() {
        userNameTextField.text = "username".localized
        userNameTextField.autocorrectionType = .no
        
        passwordTextField.text = "password".localized
        passwordTextField.autocorrectionType = .no
    }
    
    private func setUpCloseButton() {
        closeButton.alpha = 0
        closeButton.isUserInteractionEnabled = false
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
    }
    
    private func addViews() {
        view.addSubview(redCircle)
        view.addSubview(darkBlueCircle)
        view.addSubview(lightBlueCircle)
        view.addSubview(whiteCircle)
        view.addSubview(logoImageView)
        view.addSubview(headerTextsStackView)
        view.addSubview(closeButton)
        view.addSubview(userInfoStackView)
    }
    
    private func handleLoginButton(isButtonActive: Bool, isAlphaActive: Bool) {
        if isButtonActive {
            loginButton.isUserInteractionEnabled = true
        } else {
            loginButton.isUserInteractionEnabled = false
        }
        
        if isAlphaActive {
            loginButton.backgroundColor = .white
            loginLabel.textColor = .white
        } else {
            loginButton.backgroundColor = UIColor.init(white: 1, alpha: 0.4)
            loginLabel.textColor = UIColor.init(white: 1, alpha: 0.4)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, self.keyboardHeight == 0 {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    @IBAction func hidePasswordButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let userName = userNameTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        if userName.isEmpty {
            showErrorAlert(message: "Lütfen Kullanıcı Adı alanını doldurun.")
            return
        }
        
        if password.isEmpty {
            showErrorAlert(message: " Lütfen Şifre alanını doldurun.")
            return
        }
        
        if !userName.isValidUserName {
            let vc = PopupViewController.create(title: "Lütfen geçerli bir mail adresi giriniz!", description: "")
            self.present(vc, animated: true)
            return
        }
        else {
            viewModel.performLogin(userName: userName, password: password)
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        print("Forgot password button tapped")
    }
    
    @IBAction func userNameEditingBegin(_ sender: UITextField) {
        if !isKeyboardAppeared {
            isKeyboardAppeared = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateToTop()
            }
        }
        userNameTextField.alpha = 1
        passwordTextField.alpha = 0.5
        
        if sender.text == "username".localized {
            sender.text = ""
            
            self.handleLoginButton(isButtonActive: false, isAlphaActive: false)
        }
    }
    
    @IBAction func passwordEditingBegin(_ sender: UITextField) {
        if !isKeyboardAppeared {
            isKeyboardAppeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateToBottom()
                
            }
        }
        if isKeyboardAppeared {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateToTop()
                self.passwordTextField.becomeFirstResponder()
            }
        }
        sender.isSecureTextEntry = true
        
        passwordTextField.alpha = 1
        userNameTextField.alpha = 0.5
        if sender.text == "password".localized {
            sender.text = ""
            
            self.handleLoginButton(isButtonActive: false, isAlphaActive: false)
        }
        else {
            self.handleLoginButton(isButtonActive: true, isAlphaActive: true)
        }
    }
    
    @IBAction func passwordEditingChange(_ sender: UITextField) {
     
        if isKeyboardAppeared == false  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateToTop()
            }
        }
        
        if sender.text == "password".localized {
            sender.text = ""

            self.handleLoginButton(isButtonActive: false, isAlphaActive: false)
        }
        else {
            self.handleLoginButton(isButtonActive: true, isAlphaActive: true)
        }
    }
    
    @IBAction func userNameEditingEnd(_ sender: UITextField) {
        if sender.text?.count == 0 {
            sender.text = "username".localized
            
            self.handleLoginButton(isButtonActive: false, isAlphaActive: false)
        }
        else {
            if isKeyboardAppeared {
                isKeyboardAppeared = false
                self.animateToBottom()
            }
            
            self.handleLoginButton(isButtonActive: true, isAlphaActive: true)
        }
    }
    
    @IBAction func passwordEditingEnd(_ sender: UITextField) {
        if sender.text?.count == 0 {
            sender.text = "password".localized
            sender.isSecureTextEntry = false
            
            self.handleLoginButton(isButtonActive: false, isAlphaActive: false)
        }
        else {
            if isKeyboardAppeared {
                isKeyboardAppeared = false
                
                self.animateToBottom()
            }
            
            self.handleLoginButton(isButtonActive: true, isAlphaActive: true)
        }
    }
    
    @IBAction func consultButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.carrefoursaisortagi.com/dealership")! as URL, options: [:], completionHandler: nil)
    }
}


// MARK: - LoginViewModelDelegate Methods
extension LoginViewController: LoginViewModelDelegate {
    func navigateToConfirmationPage(confirmationModel: ConfirmationCreateModel) {
        let vc: ConfirmationViewController = ConfirmationViewController.create(confirmationModel: confirmationModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToOTPPage(userName: String) {
        let vc: OTPCheckViewController = OTPCheckViewController.create(userName: userName, phoneNumber: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToHomePage() {
        let vc: MainViewController = MainViewController.create(companyAndStoreModel: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loginFailed(errorMessage: String) {
        if errorMessage == "" || !errorMessage.contains("Hatalı") {
            let vc: PopupViewController = PopupViewController.create(title: "Lütfen bağlantınızı kontrol ediniz!", description: "")
            self.present(vc, animated: true)
        } else {
            let vc: LoginErrorViewController = LoginErrorViewController.create()
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Creator
extension LoginViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "LoginViewController"
        }
    }
    
    class func create() -> LoginViewController {
        let vc: LoginViewController = LoginViewController.instantiateFromNib()
        let viewModel: LoginViewModel = LoginViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
