//
//  RegisteredCardItemTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 31.12.2022.
//

import UIKit

protocol RegisteredCardItemTableViewCellDelegate {
    func selectCardButtonToggled(index: Int, cardName: String)
    func deleteCardButtonTapped(cardName: String)
}


class RegisteredCardItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    var card: MfsCard?
    var delegate: RegisteredCardItemTableViewCellDelegate?    
    var index = 0
    
    func bind(cardItem: MfsCard, isSelected: Bool) {
        card = cardItem
        cardNameLabel.text = cardItem.cardName
        cardNumberLabel.text = cardItem.cardNo
        selectButton.isSelected = isSelected
        selectButton.setImage(UIImage(systemName: "record.circle"), for: .selected)
        selectButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
   
    
    
    
    
    @IBAction func removeCardButtonClicked(_ sender: Any) {
        if let cardName = card?.cardName {
            delegate?.deleteCardButtonTapped(cardName: cardName)
        }
    }
    
    
    @IBAction func selectCardButtonClicked(_ sender: Any) {
        if let cardName = card?.cardName {
            delegate?.selectCardButtonToggled(index: index, cardName: cardName)
        }
    }
}
