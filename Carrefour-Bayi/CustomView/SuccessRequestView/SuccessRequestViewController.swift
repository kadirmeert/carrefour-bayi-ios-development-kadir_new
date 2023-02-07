//
//  SuccessRequestViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 12.12.2022.
//

import UIKit

protocol SuccessRequestViewControllerDelegate: BaseViewModelDelegate {
    func dashboardButtonClickedInPopup()
    func newRequestButtonClickedInPopup()
    func closeButtonTapped()
}

class SuccessRequestViewController: BaseViewController {

    //    MARK: - variables
    var viewModel: SuccessRequestViewModel!
    weak var delegate: SuccessRequestViewControllerDelegate?
    
    var requestID: Int?
    var requestNo: String?
    
    //    MARK: - Properties
    @IBOutlet weak var requestInfoBaseView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var requestNoLabel: UILabel!
    @IBOutlet weak var containerView: BaseView!
    
    
    private let screenMinX = UIScreen.main.bounds.minX
    private let screenMinY = UIScreen.main.bounds.minY
    
    private let screenMidX = UIScreen.main.bounds.midX
    private let screenMidY = UIScreen.main.bounds.midY
    
    private let screenMaxX = UIScreen.main.bounds.maxX
    private let screenMaxY = UIScreen.main.bounds.maxY
    
    lazy var closeButton: BaseButton = {
        let button = BaseButton(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMinY), size: CGSize(width: 50, height: 50)))
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .primaryRed
        button.tintColor = .white
        let image = UIImage(systemName: "multiply")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.black))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var firstRedCircle: UIView = {
       let view = UIView(frame: CGRect(origin: CGPoint(x: screenMinX, y: screenMinY), size: CGSize(width: 40, height: 40)))
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
        let view = UIView(frame: CGRect(origin: CGPoint(x: screenMaxX, y: screenMaxY), size: CGSize(width: 20, height: 20)))
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
    
    
    
    //    MARK: - UI Methods
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        view.addSubview(closeButton)
        view.addSubview(firstRedCircle)
        view.addSubview(secondRedCircle)
        view.addSubview(firstDarkBlueCircle)
        view.addSubview(firstLightBlueCircle)
        view.addSubview(secondLightBlueCircle)
        view.addSubview(thirdLightBlueCircle)
        view.addSubview(firstWhiteCircle)
        view.addSubview(secondWhiteCircle)
        view.addSubview(thirdWhiteCircle)
        
        containerView.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openingAnimation()
        }
        self.idLabel.text = "\(self.requestID ?? 0)"
        self.requestNoLabel.text = self.requestNo ?? "-"
    }
  
    @IBAction func dashboardButtonClicked(_ sender: UIButton) {
        delegate?.dashboardButtonClickedInPopup()
    }
    
    @IBAction func newRequestButtonClicked(_ sender: UIButton) {
        delegate?.newRequestButtonClickedInPopup()
    }
    
    
    @objc
    private func closeButtonTapped() {
        closingAnimation()
        delegate?.closeButtonTapped()
    }
    
    private func openingAnimation() {
        UIView.transition(with: containerView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 1
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.closeButton.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX - 25, y: self.containerView.frame.minY - 25), size: CGSize(width: 50, height: 50))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX - 20, y: self.containerView.frame.midY - 20), size: CGSize(width: 40, height: 40))
            
            self.secondRedCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 40, y: self.containerView.frame.maxY + 10), size: CGSize(width: 12, height: 12))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX - 10, y: self.containerView.frame.midY + 10), size: CGSize(width: 20, height: 20))
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX + 50, y: self.containerView.frame.minY - 10), size: CGSize(width: 20, height: 20))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.minX + 60, y: self.containerView.frame.maxY + 10), size: CGSize(width: 32, height: 32))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 20, y: self.containerView.frame.minY - 15), size: CGSize(width: 8, height: 8))
            
            self.firstWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 50, y: self.containerView.frame.minY - 50), size: CGSize(width: 4, height: 4))
            
            self.secondWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.midX + 20, y: self.containerView.frame.maxY + 50), size: CGSize(width: 4, height: 4))
            
            self.thirdWhiteCircle.frame = CGRect(origin: CGPoint(x: self.containerView.frame.maxX + 20, y: self.containerView.frame.midY - 20), size: CGSize(width: 4, height: 4))
        })
    }
    
    private func closingAnimation() {
        UIView.transition(with: containerView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 0
        })
        
        UIView.animate(withDuration: 1) {
            self.closeButton.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY), size: CGSize(width: 50, height: 50))
            
            self.firstRedCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMinY), size: CGSize(width: 40, height: 40))
            
            self.secondRedCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMaxY), size: CGSize(width: 12, height: 12))
            
            self.firstDarkBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMaxY), size: CGSize(width: 40, height: 40))
            
            self.firstLightBlueCircle.frame = CGRect(origin: CGPoint(x: 50, y: self.screenMinY), size: CGSize(width: 20, height: 20))
            
            self.secondLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMinX, y: self.screenMaxY), size: CGSize(width: 32, height: 32))
            
            self.thirdLightBlueCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY), size: CGSize(width: 8, height: 8))
            
            self.firstWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMidX, y: self.screenMinY), size: CGSize(width: 4, height: 4))
            
            self.secondWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMaxX, y: self.screenMinY + 100), size: CGSize(width: 4, height: 4))
            
            self.thirdWhiteCircle.frame = CGRect(origin: CGPoint(x: self.screenMidX, y: self.screenMaxY), size: CGSize(width: 4, height: 4))
        } completion: {[weak self] success in
            self?.dismiss(animated: true)
        }
    }
    
}





//    MARK: - SuccessRequestViewModelDelegate Methods
extension SuccessRequestViewController: SuccessRequestViewModelDelegate {
}





//    MARK: - Creator
extension SuccessRequestViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "SuccessRequestViewController"
        }
    }
    
    class func create(requestID: Int, RequestNo: String) -> SuccessRequestViewController {
        let vc: SuccessRequestViewController = SuccessRequestViewController.instantiateFromNib()
        let viewModel: SuccessRequestViewModel = SuccessRequestViewModel()
        vc.viewModel = viewModel
        vc.requestID = requestID
        vc.requestNo = RequestNo
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewModel.delegate = vc
        
        return vc
    }
}
