//
//  UpdateProductQuantityViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 13.12.2022.
//

import UIKit

protocol UpdateProductQuantityViewControllerDelegate {
    func updateButtonClicked(quantity: Int)
}

class UpdateProductQuantityViewController: BaseViewController {
    
    //    MARK: - Variables
    var viewModel: UpdateProductQuantityViewModel!
    var delegate: UpdateProductQuantityViewControllerDelegate?
    
    var currentQuantity: Int?
    var maxQuantityValue: Int?
    var quantityMultiplier: Int?
    
    //    MARK: - Properties
    @IBOutlet weak var containerView: BaseView!
    @IBOutlet weak var currentQuantityLabel: UITextField!
    
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
        currentQuantityLabel.layer.cornerRadius = 10
        currentQuantityLabel.layer.masksToBounds = true
        currentQuantityLabel.attributedPlaceholder =  NSAttributedString(string: "\(currentQuantity ?? 0)", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font :UIFont(name: "Montserrat-Medium", size: 17)!])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openingAnimation()
        }
//        self.currentQuantityLabel.text = "\(currentQuantity ?? 1)"
    }
    
    
    @objc
    private func closeButtonTapped() {
        closingAnimation()
    }

        
    @IBAction func updateButtonClicked(_ sender: Any) {
        if let currentQuantity {
            delegate?.updateButtonClicked(quantity: currentQuantity)
            closeButtonTapped()
        }
    }

    
    @IBAction func currentQuantityEditingChanged(_ sender: UITextField) {
        self.currentQuantityLabel.text = sender.text
        if Int(self.currentQuantityLabel.text ?? "") ?? 0 > maxQuantityValue ?? 0 {
            self.currentQuantityLabel.text = "\(maxQuantityValue ?? 0)"
        }
        self.currentQuantity = Int(self.currentQuantityLabel.text ?? "")
    }
    
//    @IBAction func minusButtonClicked(_ sender: Any) {
//        if currentQuantity != nil {
//            if let quantityMultiplier {
//                if (currentQuantity! - quantityMultiplier) >= 0 {
//                    currentQuantity! -= quantityMultiplier
//                    currentQuantityLabel.text = "\(currentQuantity!)"
//                }
//            }
//        }
//    }
//
//    @IBAction func plusButtonClicked(_ sender: Any) {
//        if currentQuantity != nil {
//            if  let quantityMultiplier, let maxQuantityValue {
//                if (currentQuantity! + quantityMultiplier) <= maxQuantityValue {
//                    currentQuantity! += quantityMultiplier
//                    currentQuantityLabel.text = "\(currentQuantity!)"
//                }
//            }
//        }
//    }
    
    
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



//    MARK: - UpdateProductQuantityViewModelDelegate Methods
extension UpdateProductQuantityViewController: UpdateProductQuantityViewModelDelegate {
}



//    MARK: - Creator
extension UpdateProductQuantityViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "UpdateProductQuantityViewController"
        }
    }
    
    class func create(currentQuantity: Int, quantityMultiplier: Int, maxQuantityValue: Int) -> UpdateProductQuantityViewController {
        let vc: UpdateProductQuantityViewController = UpdateProductQuantityViewController.instantiateFromNib()
        let viewModel: UpdateProductQuantityViewModel = UpdateProductQuantityViewModel()
        vc.viewModel = viewModel
        vc.currentQuantity = currentQuantity
//        vc.quantityMultiplier = quantityMultiplier
        vc.maxQuantityValue = maxQuantityValue
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewModel.delegate = vc
        
        return vc
    }
}

