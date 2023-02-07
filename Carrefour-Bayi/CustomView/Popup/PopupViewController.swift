//
//  PopupViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 16.09.2022.
//

import UIKit

protocol PopupViewControllerDelegate {
    func popupClosed()
}

class PopupViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: PopupViewModel!
    var delegate: PopupViewControllerDelegate?
    
    // MARK: -Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        if viewModel.descriptionText == "" {
            titleLabel.text = viewModel.titleText
            descriptionLabel.text = viewModel.descriptionText
            contentViewHeightConstraint.constant = contentViewHeightConstraint.constant * 0.7
        } else {
            titleLabel.text = viewModel.titleText
            descriptionLabel.text = viewModel.descriptionText
        }
        
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.popupClosed()
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.popupClosed()
        }
    }
}

// MARK: -PopupViewModelDelegate Methods
extension PopupViewController: PopupViewModelDelegate {
    
}

// MARK: - Creator
extension PopupViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "PopupViewController"
        }
    }
    
    class func create(title: String, description: String) -> PopupViewController {
        let vc: PopupViewController = PopupViewController.instantiateFromNib()
        let viewModel: PopupViewModel = PopupViewModel()
        
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        viewModel.delegate = vc
        viewModel.titleText = title
        viewModel.descriptionText = description
        
        return vc
    }
}
