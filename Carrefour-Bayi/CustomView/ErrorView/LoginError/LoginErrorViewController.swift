//
//  LoginErrorViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 8.08.2022.
//

import UIKit

class LoginErrorViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: LoginErrorViewModel!
    
    private let screenMinX = UIScreen.main.bounds.minX
    private let screenMinY = UIScreen.main.bounds.minY
    
    private let screenMidX = UIScreen.main.bounds.midX
    private let screenMidY = UIScreen.main.bounds.midY
    
    private let screenMaxX = UIScreen.main.bounds.maxX
    private let screenMaxY = UIScreen.main.bounds.maxY
    
    // MARK: -Views
    @IBOutlet weak var containerView: BaseView!
    
//    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    lazy var closeButton: BaseButton = {
        let button = BaseButton(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMinY), size: CGSize(width: 50, height: 50)))
        button.layer.cornerRadius = button.frame.width / 2
        button.backgroundColor = .primaryRed
        button.tintColor = .white
        let image = UIImage(systemName: "multiply")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.black))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var firstDarkBlueCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY), size: CGSize(width: 40, height: 40)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryDarkBlue
        return view
    }()
    
    lazy var secondDarkBlueCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMidY), size: CGSize(width: 20, height: 20)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryDarkBlue
        return view
    }()
    
    lazy var firstLightBlueCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 50, y: screenMinY), size: CGSize(width: 20, height: 20)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var secondLightBlueCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMaxY), size: CGSize(width: 32, height: 32)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var thirdLightBlueCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMinY), size: CGSize(width: 8, height: 8)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var firstWhiteCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMidX, y: screenMinY), size: CGSize(width: 4, height: 4)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .white
        return view
    }()
    
    lazy var secondWhiteCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMinY), size: CGSize(width: 4, height: 4)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .white
        return view
    }()
    
    lazy var thirdWhiteCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMidX, y: screenMaxY), size: CGSize(width: 4, height: 4)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .white
        return view
    }()
    
    lazy var firstRedCircle: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMaxY), size: CGSize(width: 12, height: 12)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .red
        return view
    }()
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        view.addSubview(closeButton)
        view.addSubview(firstDarkBlueCircle)
        view.addSubview(secondDarkBlueCircle)
        view.addSubview(firstLightBlueCircle)
        view.addSubview(secondLightBlueCircle)
        view.addSubview(thirdLightBlueCircle)
        view.addSubview(firstWhiteCircle)
        view.addSubview(secondWhiteCircle)
        view.addSubview(thirdWhiteCircle)
        view.addSubview(firstRedCircle)
        
        containerView.alpha = 0
        
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSMutableAttributedString(string: "Şifremi\nUnuttum?".localized, attributes: attributes)
//        forgotPasswordLabel.attributedText = attributedText
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openingAnimation()
        }
    }
    
    private func openingAnimation() {
        UIView.transition(with: containerView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 1
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.closeButton.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX - 25, y: self.containerView.frame.minY - 25), size: CGSize(width: 50, height: 50))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX - 20, y: self.containerView.frame.minY + 50), size: CGSize(width: 40, height: 40))
            
            self.secondDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX - 10, y: self.containerView.frame.midY + 10), size: CGSize(width: 20, height: 20))
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX + 70, y: self.containerView.frame.minY - 10), size: CGSize(width: 20, height: 20))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX + 20, y: self.containerView.frame.maxY - 16), size: CGSize(width: 32, height: 32))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 30, y: self.containerView.frame.minY - 15), size: CGSize(width: 8, height: 8))
            
            self.firstWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 10, y: self.containerView.frame.minY - 50), size: CGSize(width: 4, height: 4))
            
            self.secondWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 30, y: self.containerView.frame.maxY + 40), size: CGSize(width: 4, height: 4))
            
            self.thirdWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX + 20, y: self.containerView.frame.midY - 20), size: CGSize(width: 4, height: 4))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 40, y: self.containerView.frame.maxY + 12), size: CGSize(width: 12, height: 12))
        })
    }
    
    private func closingAnimation() {
        UIView.transition(with: containerView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 0
        })
        
        UIView.animate(withDuration: 1) {
            self.closeButton.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY), size: CGSize(width: 50, height: 50))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY), size: CGSize(width: 40, height: 40))
            
            self.secondDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMidY), size: CGSize(width: 20, height: 20))
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: 50, y: self.screenMinY), size: CGSize(width: 20, height: 20))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMaxY), size: CGSize(width: 32, height: 32))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY), size: CGSize(width: 8, height: 8))
            
            self.firstWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMidX, y: self.screenMinY), size: CGSize(width: 4, height: 4))
            
            self.secondWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY + 100), size: CGSize(width: 4, height: 4))
            
            self.thirdWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMidX, y: self.screenMaxY), size: CGSize(width: 4, height: 4))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMaxY), size: CGSize(width: 12, height: 12))
        } completion: {[weak self] success in
            self?.dismiss(animated: true)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        closingAnimation()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        print("Forgot password button clicked")
    }
}

// MARK: -LoginErrorViewModelDelegate Methods
extension LoginErrorViewController: LoginErrorViewModelDelegate {
    
}

// MARK: - Creator
extension LoginErrorViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "LoginErrorViewController"
        }
    }
    
    class func create() -> LoginErrorViewController {
        let vc: LoginErrorViewController = LoginErrorViewController.instantiateFromNib()
        let viewModel: LoginErrorViewModel = LoginErrorViewModel()
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewModel.delegate = vc
        
        return vc
    }
}
