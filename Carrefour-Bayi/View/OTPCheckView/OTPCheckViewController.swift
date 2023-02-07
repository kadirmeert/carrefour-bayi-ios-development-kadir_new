//
//  OTPCheckViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 28.07.2022.
//

import UIKit

class OTPCheckViewController: BaseViewController {
    
    // MARK: -Properties
    var viewModel: OTPCheckViewModel!
    
    let ratio = UIScreen.main.bounds.height / 812.0
    
    let screenMinX = UIScreen.main.bounds.minX
    let screenMinY = UIScreen.main.bounds.minY
    
    let otpTimeoutValue = 120
    var isOTPSucceed = false
    var lightBlueCircleDiameter: CGFloat = 0.0
    
    var whiteCircleDiameter: CGFloat = 0.0
    
    // MARK: -Views
    lazy var lightBlueCircle: UIView = {
        lightBlueCircleDiameter = 1226.0 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY), size: CGSize(width: 50, height: 50)))
        view.backgroundColor = .primaryLightBlue
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var whiteCircle: UIView = {
        whiteCircleDiameter = 448.0 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY), size: CGSize(width: 50, height: 50)))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var smsVerificationLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var verifyButton: BaseButton!
    @IBOutlet weak var sendReCode: UIButton!
    @IBOutlet weak var otpTextField: OTPTextField!
    
    var appDidEnterBackgroundDate: Date?
    var previousDate = Date()
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        view.addSubview(lightBlueCircle)
        view.addSubview(whiteCircle)
        view.addSubview(logoImageView)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        setUpSendReCodeButton()
        setUpOtpTextField()
        setUpProgressView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateToBot()
        }
    }
    
    private func animateToBot() {
        UIView.animate(withDuration: 1, animations: {
            self.otpTextField.becomeFirstResponder()
            
            self.lightBlueCircle.frame = CGRect(origin: CGPoint(x: -244.0 * self.ratio, y: -198.0 * self.ratio), size: CGSize(width: self.lightBlueCircleDiameter, height: self.lightBlueCircleDiameter))
            self.lightBlueCircle.layer.cornerRadius = self.lightBlueCircle.frame.height / 2
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: -142 * self.ratio, y: -317 * self.ratio), size: CGSize(width: self.whiteCircleDiameter, height: self.whiteCircleDiameter))
            self.whiteCircle.layer.cornerRadius = self.whiteCircle.frame.height / 2
        })
    }
    
    private func setUpSendReCodeButton() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Bold", size: 13)!,
            .foregroundColor: UIColor.primaryTitleBlue.cgColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "Yeni Kod Gönder",
            attributes: attributes
        )
        
        sendReCode.setAttributedTitle(attributeString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        if !isOTPSucceed {
            guard let previousDate = appDidEnterBackgroundDate else { return }
            let calendar = Calendar.current
            let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
            let seconds = difference.second!
            reStartProgressView(value: progressView.currentCounterValue - seconds)
        }
    }
    
    private func setUpOtpTextField() {
        otpTextField.clearOTP()
        otpTextField.otpDelegate = self
        otpTextField.configure(with: 6)
    }
    
    private func setUpProgressView() {
        progressView.delegate = self
        progressView.isMovingClockWise = true
        progressView.isTextLabelHidden = true
        progressView.start(beginingValue: otpTimeoutValue, interval: 1.0)
    }
    
    private func reStartProgressView(value: Int) {
        progressView.delegate = self
        progressView.isMovingClockWise = true
        progressView.isTextLabelHidden = true
        if value < 2 {
            progressView.start(beginingValue: otpTimeoutValue, interval: 1.0)
        } else {
            progressView.start(beginingValue: value, interval: 1.0, elapsedTime: 0)
        }
    }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        if let code = otpTextField.text, code.count == otpTextField.digitalLabelsCount {
            viewModel.performConfirmOrOTPCheck(code: code)
        }
        else {
            let vc: PopupViewController = PopupViewController.create(title: "Lütfen SMS kodu alanını doldurun.", description: "")
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: UIButton) {
        setUpProgressView()
        verifyButton.isUserInteractionEnabled = true
        viewModel.performResendCode()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            self.lightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY), size: CGSize(width: 50, height: 50))
            self.lightBlueCircle.layer.cornerRadius = self.lightBlueCircle.frame.height / 2
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY), size: CGSize(width: 50, height: 50))
            self.whiteCircle.layer.cornerRadius = self.whiteCircle.frame.height / 2
        } completion: {[weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: -TimerHandleDelegate Methods
extension OTPCheckViewController: TimerHandleDelegate {
    func counterUpdateTimeValue(with sender: CircularProgressView, newValue: Int) {
        previousDate = Date()
        counterLabel.text = "\(newValue)"
    }
    
    func didStartTimer(sender: CircularProgressView) {
        self.sendReCode.isHidden = true
        self.sendReCode.isUserInteractionEnabled = false
        self.verifyButton.isUserInteractionEnabled = true
        self.verifyButton.alpha = 1
    }
    
    func didEndTimer(sender: CircularProgressView) {
        self.verifyButton.isUserInteractionEnabled = false
        self.sendReCode.isHidden = false
        self.sendReCode.isUserInteractionEnabled = true
        self.verifyButton.alpha = 0.5
        let vc: OTPCheckErrorViewController = OTPCheckErrorViewController.create(timerValue: 0, isResendButtonActive: true)
        vc.titleText = "Süreniz Bitti!"
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
}

// MARK: -OTPTextFieldDelegate Methods
extension OTPCheckViewController: OTPTextFieldDelegate, UITextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
}

// MARK: -OTPCheckErrorViewControllerDelegate Methods
extension OTPCheckViewController: OTPCheckErrorViewControllerDelegate {
    func resendCode() {
        viewModel.performResendCode()
    }
    func closeButtonTapped() {
    }
}

// MARK: -OTPCheckViewModelDelegate Methods
extension OTPCheckViewController: OTPCheckViewModelDelegate {
    func otpCodeCheckSuccess() {
        progressView.delegate = nil
        isOTPSucceed = true
        let vc: SuccessLoginViewController = SuccessLoginViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resendCodeSuccess() {
        setUpProgressView()
        setUpOtpTextField()
    }
    
    func otpCheckFailed(error: String) {
        let vc: OTPCheckErrorViewController = OTPCheckErrorViewController.create(timerValue: progressView.currentCounterValue, isResendButtonActive: false)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func contentFailed(error: String) {
        let vc: OTPCheckErrorViewController = OTPCheckErrorViewController.create(timerValue: progressView.currentCounterValue, isResendButtonActive: false)
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - Creator
extension OTPCheckViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "OTPCheckViewController"
        }
    }
    
    ///confirmationRequest parametresi nil değilse kullanıcı confirmation sayfasından gelmiştir ve sms doğrulama işlemi confirmation apisiyle yapılacaktır.
    ///confirmationRequest parametresi nil geldiyse userName, phoneNumber parametreleri login sayfasından gelmiştir ve doğrulama işlemi otpCheck apisiyle yapılacaktır. Otp Check sayfası ilk açıldığında resend code apisi ile kullanıcıya sms gönderilmesi sağlanır. Bunun kontrolünü de viewmodel içerisinde viewWillAppear'da codeId kontrolüyle sağlanmaktadır.
    class func create(userName: String, phoneNumber: String, codeId: Int = 0, confirmationRequest: ConfirmationRequestDTO? = nil) -> OTPCheckViewController {
        let vc: OTPCheckViewController = OTPCheckViewController.instantiateFromNib()
        let viewModel: OTPCheckViewModel = OTPCheckViewModel(userName: userName, phoneNumber: phoneNumber, codeId: codeId, confirmationRequest: confirmationRequest)
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
