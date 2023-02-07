//
//  GeneralPopupViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 31.08.2022.
//

import UIKit

class GeneralPopupViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: GeneralPopupViewModel!
    
    private let screenMinX = UIScreen.main.bounds.minX
    private let screenMinY = UIScreen.main.bounds.minY
    
    private let screenMidX = UIScreen.main.bounds.midX
    private let screenMidY = UIScreen.main.bounds.midY
    
    private let screenMaxX = UIScreen.main.bounds.maxX
    private let screenMaxY = UIScreen.main.bounds.maxY
    
    // MARK: -Views
    @IBOutlet weak var containerView: BaseView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    lazy var closeButton: BaseButton = {
        let button = BaseButton(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMinY), size: CGSize(width: 50, height: 50)))
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .primaryRed
        button.setImage(UIImage(named: "icon_Close_white"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var firstLightBlueCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMidX, y: screenMinY), size: CGSize(width: 8, height: 8)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var secondLightBlueCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY), size: CGSize(width: 20, height: 20)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var thirdLightBlueCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMaxY), size: CGSize(width: 32, height: 32)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryLightBlue
        return view
    }()
    
    lazy var firstRedCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX - 40, y: screenMidY), size: CGSize(width: 40, height: 40)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryRed
        return view
    }()
    
    lazy var secondRedCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMaxY), size: CGSize(width: 12, height: 12)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryRed
        return view
    }()
    
    lazy var firstDarkBlueCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMidY), size: CGSize(width: 20, height: 20)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .primaryDarkBlue
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
        view.addSubview(firstLightBlueCircle)
        view.addSubview(secondLightBlueCircle)
        view.addSubview(thirdLightBlueCircle)
        view.addSubview(firstRedCircle)
        view.addSubview(secondRedCircle)
        view.addSubview(firstDarkBlueCircle)
        
        containerView.alpha = 0
        
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
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 30, y: self.containerView.frame.minY - 40), size: CGSize(width: 8, height: 8))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX + 60, y: self.containerView.frame.minY - 10), size: CGSize(width: 20, height: 20))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX - 16, y: self.containerView.frame.midY + 80), size: CGSize(width: 32, height: 32))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX - 20, y: self.containerView.frame.minY + 100), size: CGSize(width: 40, height: 40))
            
            self.secondRedCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX + 10, y: self.containerView.frame.midY + 100 ), size: CGSize(width: 12, height: 12))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX - 10, y: self.containerView.frame.midY - 20), size: CGSize(width: 20, height: 20))
        })
    }
    
    private func closingAnimation() {
        UIView.transition(with: containerView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 0
        })
        
        UIView.animate(withDuration: 1) {
            self.closeButton.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY), size: CGSize(width: 50, height: 50))
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMidX, y: self.screenMinY), size: CGSize(width: 8, height: 8))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY), size: CGSize(width: 20, height: 20))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMaxY), size: CGSize(width: 32, height: 32))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX - 40, y: self.screenMidY), size: CGSize(width: 40, height: 40))
            
            self.secondRedCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMaxY), size: CGSize(width: 12, height: 12))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMidY), size: CGSize(width: 20, height: 20))
        } completion: {[weak self] success in
            self?.dismiss(animated: true)
        }
    }
    
    @IBAction func dashboardButtonClicked(_ sender: UIButton) {
        print("dashboard button clicked")
    }
    
    @IBAction func ctaButtonClicked(_ sender: UIButton) {
        print("cta button clicked")
    }
    
    @objc
    private func closeButtonTapped() {
        closingAnimation()
    }
}

// MARK: -GeneralPopupViewModelDelegate Methods
extension GeneralPopupViewController: GeneralPopupViewModelDelegate {
    
}

// MARK: - Creator
extension GeneralPopupViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "GeneralPopupViewController"
        }
    }
    
    class func create() -> GeneralPopupViewController {
        let vc: GeneralPopupViewController = GeneralPopupViewController.instantiateFromNib()
        let viewModel: GeneralPopupViewModel = GeneralPopupViewModel()
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewModel.delegate = vc
        
        return vc
    }
}
