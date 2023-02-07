//
//  NewCreditCardTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 30.12.2022.
//

import UIKit

class NewCreditCardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    
    func bind() {
        
    }
    
    
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        stack1.isHidden.toggle()
    }
    
    
    
}
