//
//  SuccessLoginViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.08.2022.
//

import UIKit

class SuccessLoginViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: SuccessLoginViewModel!
    
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
    
    // MARK: -Views
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    lazy var redCircle: UIView = {
        redCircleDiameter = 751 * ratio
        
        redCircleX = -118.0 * ratio
        redCircleY = 294 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: redCircleX, y: redCircleY), size: CGSize(width: redCircleDiameter, height: redCircleDiameter)))
        view.backgroundColor = .primaryRed
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var darkBlueCircle: UIView = {
        darkBlueCircleDiameter = 842 * ratio
        
        darkBlueCircleX = -497 * ratio
        darkBlueCircleY = 0 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: darkBlueCircleX, y: darkBlueCircleY), size: CGSize(width: darkBlueCircleDiameter, height: darkBlueCircleDiameter)))
        view.backgroundColor = .primaryDarkBlue
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var lightBlueCircle: UIView = {
        lightBlueCircleDiameter = 590 * ratio
        
        lightBlueCircleX = 88 * ratio
        lightBlueCircleY = -22 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: lightBlueCircleX, y: lightBlueCircleY), size: CGSize(width: lightBlueCircleDiameter, height: lightBlueCircleDiameter)))
        view.backgroundColor = .primaryLightBlue
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var whiteCircle: UIView = {
        whiteCircleDiameter = 427 * ratio
        
        whiteCircleX = -118 * ratio
        whiteCircleY = -292 * ratio
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: whiteCircleX, y: whiteCircleY), size: CGSize(width: whiteCircleDiameter, height: whiteCircleDiameter)))
        view.backgroundColor = .white
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    weak var circleView: CircularTransititon?
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        view.addSubview(redCircle)
        view.addSubview(darkBlueCircle)
        view.addSubview(lightBlueCircle)
        view.addSubview(whiteCircle)
        view.addSubview(logoImageView)
        view.addSubview(containerStackView)
        
        checkImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        
        let circleView = CircularTransititon(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0))
        circleView.backgroundColor = UIColor.clear
        view.addSubview(circleView)
        self.circleView = circleView
        
        openingAnimation()
    }
    
    private func openingAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.checkImageView.transform = CGAffineTransform(rotationAngle: 0)
            
            self.redCircle.frame = CGRect(origin: CGPoint(x: -118 * self.ratio, y: 194 * self.ratio), size: CGSize(width: self.redCircleDiameter, height: self.redCircleDiameter))
            
            self.darkBlueCircle.frame = CGRect(origin: CGPoint(x: -362 * self.ratio, y: -94 * self.ratio), size: CGSize(width: self.darkBlueCircleDiameter, height: self.darkBlueCircleDiameter))
            
            self.lightBlueCircle.frame = CGRect(origin: CGPoint(x: -22 * self.ratio, y: -122 * self.ratio), size: CGSize(width: self.lightBlueCircleDiameter, height: self.lightBlueCircleDiameter))
            
            self.whiteCircle.frame = CGRect(origin: CGPoint(x: -118 * self.ratio, y: -292 * self.ratio), size: CGSize(width: self.whiteCircleDiameter, height: self.whiteCircleDiameter))
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.closingAnimation()
            }
        }
    }
    
    private func closingAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.checkImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            self.circleView?.resizeCircle(summand: 1000, duration: 0.2)
        } completion: { _ in
            self.dismiss(animated: true) {
                let vc: MainViewController = MainViewController.create(companyAndStoreModel: self.viewModel.companyAndStoreModel)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}

// MARK: -SuccessLoginViewModelDelegate Methods
extension SuccessLoginViewController: SuccessLoginViewModelDelegate {
    
}

// MARK: - Creator
extension SuccessLoginViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "SuccessLoginViewController"
        }
    }
    
    class func create() -> SuccessLoginViewController {
        let vc: SuccessLoginViewController = SuccessLoginViewController.instantiateFromNib()
        let viewModel: SuccessLoginViewModel = SuccessLoginViewModel()
        vc.viewModel = viewModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        viewModel.delegate = vc
        
        return vc
    }
}
