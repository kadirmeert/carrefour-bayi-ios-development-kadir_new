//
//  ProductCategoriesTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 16.12.2022.
//

import UIKit


protocol ProductCategoriesTableViewCellDelegate {
    func productSelectedSuccess(products: AisleModel)
    func searchProductClicked(searchText: String)
    func contentFailed(message: String)
    func getAllParameters(ReyonKodu: Int, AnaGrupKodu: Int, AnaHamKodu: Int, MalGrupKodu: Int)
}


class ProductCategoriesTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //    MARK: - properties
    var delegate: ProductCategoriesTableViewCellDelegate?
    var viewModel = ProductCategoriesTableViewCellViewModel()
    
    private var aislesPickerView: UIPickerView = UIPickerView()
    private var mainProductsPickerView: UIPickerView = UIPickerView()
    private var mainGroupsPickerView: UIPickerView = UIPickerView()
    private var productGroupsPickerView: UIPickerView = UIPickerView()
    
    private var selectedAisle: AisleModel?
    private var selectedMainProduct: AisleModel?
    private var selectedMainGroup: AisleModel?
    private var selectedProductGroup: AisleModel?
    
    private var searchSelectedAisle: [AisleModel]?
    private var searchSelectedMainProduct: [AisleModel]?
    private var searchSelectedMainGroup: [AisleModel]?
    private var searchSelectedProductGroup: [AisleModel]?
    
    var searchAisleCode: Int?
   

    
    //    MARK: - views
    
    @IBOutlet weak var searchProductTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var aisleTextField: UITextField!
    @IBOutlet weak var mainProductTextField: UITextField!
    @IBOutlet weak var mainGroupTextField: UITextField!
    @IBOutlet weak var productGroupTextField: UITextField!
    
    @IBOutlet weak var getAisleButton: UIButton!
    @IBOutlet weak var getMainProductButton: UIButton!
    @IBOutlet weak var getMainGroupButton: UIButton!
    @IBOutlet weak var getProductGroupButton: UIButton!
    
    @IBOutlet weak var aisleBaseView: BaseView!
    @IBOutlet weak var mainProductBaseView: BaseView!
    @IBOutlet weak var mainGroupBaseView: BaseView!
    @IBOutlet weak var productGroupBaseView: BaseView!
    
    
    func bind(aislesModel: [AisleModel]) {
        viewModel.delegate = self
        viewModel.aislesModel = aislesModel
        setupPickerViews()
    }
    func search(aislesModel: [AisleModel], searchAisleCode: Int) {
        viewModel.delegate = self
        viewModel.aislesModel = aislesModel
        self.searchAisleCode = searchAisleCode
        searchSelectedAisle = aislesModel
        searchSelectedMainProduct = aislesModel
        searchSelectedMainGroup = aislesModel
        searchSelectedProductGroup = aislesModel
        setupPickerViews()
        
    }
    
    private func setupPickerViews() {
        aislesPickerView.delegate = self
        aislesPickerView.dataSource = self
        aisleTextField.inputView = aislesPickerView
        aisleTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(aisleSelected))
        
        mainProductsPickerView.delegate = self
        mainProductsPickerView.dataSource = self
        mainProductTextField.inputView = mainProductsPickerView
        mainProductTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(mainProductSelected))
        
        mainGroupsPickerView.delegate = self
        mainGroupsPickerView.dataSource = self
        mainGroupTextField.inputView = mainGroupsPickerView
        mainGroupTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(mainGroupSelected))
    
        productGroupsPickerView.delegate = self
        productGroupsPickerView.dataSource = self
        productGroupTextField.inputView = productGroupsPickerView
        productGroupTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(productGroupSelected))
    }
    
//
    @objc
    private func aisleSelected() {
        if let aisleName = selectedAisle?.Ad, let aisleCode = selectedAisle?.Kod {
            aisleTextField.text = aisleName
            viewModel.getMainProducts(aisleCode: aisleCode)
            
        }
    }
    @objc
    private func mainGroupSelected() {
        if let mainGroupName = selectedMainGroup?.Ad, let mainGroupCode = selectedMainGroup?.Kod {
            mainGroupTextField.text = mainGroupName
            viewModel.getProductGroups(mainGroupCode: mainGroupCode)
        }
    }
    @objc
    private func mainProductSelected() {
        if let mainProductName = selectedMainProduct?.Ad, let mainProductCode = selectedMainProduct?.Kod {
            mainProductTextField.text = mainProductName
            viewModel.getMainGroups(mainProductCode: mainProductCode)
        }
    }
    @objc
    private func productGroupSelected() {
        if let productGroupName = selectedProductGroup?.Ad, let selectedProductGroup = selectedProductGroup {
            productGroupTextField.text = productGroupName
            delegate?.productSelectedSuccess(products: selectedProductGroup)
            getAllParameters()
        }
    }
    
    func getAllParameters(){
        delegate?.getAllParameters(ReyonKodu: selectedAisle?.Kod ?? 0, AnaGrupKodu: selectedMainGroup?.Kod ?? 0, AnaHamKodu: selectedMainProduct?.Kod ?? 0, MalGrupKodu: selectedProductGroup?.Kod ?? 0)
        
    }

    
    @IBAction func getAisleButtonClicked(_ sender: Any) {
        aisleTextField.becomeFirstResponder()
    }
    @IBAction func getMainProductButtonClicked(_ sender: Any) {
        mainProductTextField.becomeFirstResponder()
    }
    @IBAction func getMainGroupButtonClicked(_ sender: Any) {
        mainGroupTextField.becomeFirstResponder()
    }
    @IBAction func getProductGroupButtonClicked(_ sender: Any) {
        productGroupTextField.becomeFirstResponder()
    }
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        if let searchText = searchProductTextField.text, searchText != "" {
            delegate?.searchProductClicked(searchText: searchText)
        }
    }
}



//    MARK: - ProductCategories TableViewCell ViewModelDelegate Methods
extension ProductCategoriesTableViewCell: ProductCategoriesTableViewCellViewModelDelegate {
    func getMainProductsSuccess() {
        self.mainProductBaseView.alpha = 1
        self.mainProductBaseView.isUserInteractionEnabled = true
    }
    
    func getMainGroupsSuccess() {
        self.mainGroupBaseView.alpha = 1
        self.mainGroupBaseView.isUserInteractionEnabled = true
    }
    
    func getProductGroupsSuccess() {
        self.productGroupBaseView.alpha = 1
        self.productGroupBaseView.isUserInteractionEnabled = true
    }
    
    func pageContentFailed(message: String) {
        delegate?.contentFailed(message: "Bu kategori için seçenek bulunamadı.")
    }
}




//    MARK: - PickerView delegate & dataSource
extension ProductCategoriesTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case aislesPickerView:
                return ((viewModel.aislesModel != nil) ? viewModel.aislesModel!.count : 0)
            case mainProductsPickerView:
                return ((viewModel.mainProductsModel != nil) ? viewModel.mainProductsModel!.count : 0)
            case mainGroupsPickerView:
                return ((viewModel.mainGroupsModel != nil) ? viewModel.mainGroupsModel!.count : 0)
            case productGroupsPickerView:
                return ((viewModel.productGroupsModel != nil) ? viewModel.productGroupsModel!.count : 0)
            default:
                return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.width - 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRectMake(0, 0, self.frame.size.width - 50, 30));
        label.lineBreakMode = .byWordWrapping;
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Medium", size: 14)!
        label.sizeToFit()
        
        switch pickerView {
            case aislesPickerView:
                if let aisleName = viewModel.aislesModel?[row].Ad {
                    label.text = aisleName
                }
            case mainProductsPickerView:
                if let mainProductsName = viewModel.mainProductsModel?[row].Ad {
                    label.text = mainProductsName
                }
            case mainGroupsPickerView:
                if let mainGroupsName = viewModel.mainGroupsModel?[row].Ad {
                    label.text = mainGroupsName
                }
            case productGroupsPickerView:
                if let productGroupsName = viewModel.productGroupsModel?[row].Ad {
                    label.text = productGroupsName
                }
            default:
                label.text = "None"
        }
        return label;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
            case aislesPickerView:
                if let aisleModel = viewModel.aislesModel?[row] {
                    selectedAisle = aisleModel
                }
            case mainProductsPickerView:
                if let mainProductsModel = viewModel.mainProductsModel?[row] {
                    selectedMainProduct = mainProductsModel
                }
            case mainGroupsPickerView:
                if let mainGroupModel = viewModel.mainGroupsModel?[row] {
                    selectedMainGroup = mainGroupModel
                }
            case productGroupsPickerView:
                if let productGroupsModel = viewModel.productGroupsModel?[row] {
                    selectedProductGroup = productGroupsModel
                }
            default:
                break
        }
    }
}



