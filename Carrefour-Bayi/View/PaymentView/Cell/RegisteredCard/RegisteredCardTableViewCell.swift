//
//  RegisteredCardTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 19.12.2022.
//

import UIKit

protocol RegisteredCardTableViewCellDelegate {
    func deleteRegisteredCardClicked(cardName: String)
    func selectButtonToggledInRegisteredCardsSection()
    func registeredCardClickedForPayment(cardName: String)
}


class CreditCardSection {
    var cardData: MfsCard?
    var isSelected: Bool = false
    
    init(cardData: MfsCard? = nil, isSelected: Bool = false) {
        self.cardData = cardData
        self.isSelected = isSelected
    }
}



class RegisteredCardTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var masterPassLogo: UIImageView!
    
    var delegate: RegisteredCardTableViewCellDelegate?
    private var cardSections = [CreditCardSection]()
    var selectedCardItem: CreditCardSection?
    
    
    func bind(isSelectedRegisteredCard: Bool, registeredCards: [MfsCard]?) {
        if let registeredCards = registeredCards {
            cardSections = registeredCards.map({ cardItem in
                return CreditCardSection(cardData: cardItem)
            })
            tableView.reloadData()
        }
        selectButton.isSelected = isSelectedRegisteredCard
        creditCardLabel.isHidden = !isSelectedRegisteredCard
        masterPassLogo.isHidden = !isSelectedRegisteredCard
        tableView.isHidden = !isSelectedRegisteredCard
        initUI()
    }
    
    
    private func initUI() {
        selectButton.setImage(UIImage(systemName: "record.circle"), for: .selected)
        selectButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectButton.addShadow(shadowColor: UIColor.primaryDarkBlue, shadowOpacity: 0.4)
        
        tableView.delegate = self
        tableView.dataSource = self
        RegisteredCardItemTableViewCell.registerSelf(tableView: tableView)
    }
    
    
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        delegate?.selectButtonToggledInRegisteredCardsSection()
    }
}





//    MARK: - Tableview delegate & data source
extension RegisteredCardTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredCardItemTableViewCell") as! RegisteredCardItemTableViewCell
        if let cardData = cardSections[indexPath.row].cardData {
            cell.bind(cardItem: cardData, isSelected: cardSections[indexPath.row].isSelected)
            cell.index = indexPath.row
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}





//    MARK: - RegisteredCardItem TableViewCellDelegate
extension RegisteredCardTableViewCell: RegisteredCardItemTableViewCellDelegate {
    func selectCardButtonToggled(index: Int, cardName: String) {
        cardSections.forEach { cardItem in
            cardItem.isSelected = false
        }
        cardSections[index].isSelected.toggle()
        selectedCardItem = cardSections[index]
        tableView.reloadData()
        self.delegate?.registeredCardClickedForPayment(cardName: cardName)
    }
    
    func deleteCardButtonTapped(cardName: String) {
        self.delegate?.deleteRegisteredCardClicked(cardName: cardName)
    }
}
