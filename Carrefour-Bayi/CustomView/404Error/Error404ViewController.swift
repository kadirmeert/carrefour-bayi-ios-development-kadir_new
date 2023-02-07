//
//  Error404ViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 16.10.2022.
//

import UIKit

protocol Error404ViewControllerDelegate {
    func backButtonTappedInError404()
}


class Error404ViewController: BaseViewController {

    // MARK: -Properties
    var viewModel: Error404ViewModel!
    var delegate: Error404ViewControllerDelegate?
    
    // MARK: -Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fourZeroFourLabel: UILabel!
    
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    
    //    MARK: - UI Methods -
    private func initUI() {
        backButton.setTitle("", for: .normal)
        fourZeroFourLabel.addShadow(cornerRadius: 4, shadowColor: .darkBlue, shadowOffset: CGSize(width: 2, height: 10), shadowOpacity: 0.25, shadowRadius: 4 )
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegate?.backButtonTappedInError404()
    }
    

}



// MARK: - Creator
extension Error404ViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "Error404ViewController"
        }
    }
    
    class func create() -> Error404ViewController {
        let vc: Error404ViewController = Error404ViewController.instantiateFromNib()
        let viewModel: Error404ViewModel = Error404ViewModel()
        
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
//        viewModel.delegate = vc
        
        return vc
    }
}

