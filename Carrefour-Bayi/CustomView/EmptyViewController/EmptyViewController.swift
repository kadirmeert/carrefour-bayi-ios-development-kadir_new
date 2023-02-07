//
//  EmptyViewController.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 27.10.2022.
//

import UIKit


class EmptyViewController: UIViewController {

    //    MARK: - Properties -
    
    
    //    MARK: - Views -
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //    MARK: - UI Methods -
    private func initUI(){
        
    }
    
}


extension EmptyViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "EmptyViewController"
        }
    }
    
    class func create() -> EmptyViewController {
        let vc: EmptyViewController = EmptyViewController.instantiateFromNib()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
}
