//
//  ConfirmationViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 10.08.2022.
//

import Foundation

protocol ConfirmationViewModelDelegate: BaseViewModelDelegate {
    func navigateToOtpPage(confirmationRequest: ConfirmationRequestDTO)
    func contentFailed(errorMessage: String)
}

class ConfirmationViewModel: BaseViewModel {
    weak var delegate: ConfirmationViewModelDelegate?
    private var cityRepository: CityRepository
    private var accountRepository: AccountRepository
    
    var confirmationModel: ConfirmationCreateModel?
    
    var cities: [City]?
    var districts: [District]
    var selectedCity: City?
    var selectedDistrict: District?
    
    init(confirmationModel: ConfirmationCreateModel? = nil,
         cityRepository: CityRepository = RepositoryProvider.cityRepository,
         accountRepository: AccountRepository = RepositoryProvider.accountRepository,
         cities: [City] = [],
         districts: [District] = []
    ) {
        self.confirmationModel = confirmationModel
        self.accountRepository = accountRepository
        self.cityRepository = cityRepository
        self.cities = cities
        self.districts = districts
    }
    
    override func viewWillAppear() {
        if let confirmationModel = confirmationModel, confirmationModel.isConfirmCityDistrict {
            getCities()
        }
    }
    
    func getCities() {
        baseVMDelegate?.contentWillLoad()
        
        cityRepository.getCities {[weak self] citiesResponse in
            self?.baseVMDelegate?.contentDidLoad()
            
            print("**************\nCities arrived: \(citiesResponse)**************\n")
            
            self?.cities = citiesResponse
        } failure: {[weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            
            self?.delegate?.contentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
    }
    
    func getDistricts(city: City) {
        selectedCity = city
        baseVMDelegate?.contentWillLoad()
        
        cityRepository.getDistricts(cityId: city.Id) {[weak self] districtsResponse in
            self?.baseVMDelegate?.contentDidLoad()
            
            print("**************\n Districts arrived: \(districtsResponse)**************\n")
            
            self?.districts = districtsResponse
        } failure: {[weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            
            self?.delegate?.contentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
    }
    
    func performConfirmation(phoneNumber: String) {
        baseVMDelegate?.contentWillLoad()
        guard let confirmationModel = confirmationModel else {
            self.baseVMDelegate?.contentDidLoad()
            return
        }
        
        var confirmationRequestDTO: ConfirmationRequestDTO?
        
        if confirmationModel.isConfirmCityDistrict {
            guard let selectedCity = selectedCity, let selectedDistrict = selectedDistrict else {
                self.baseVMDelegate?.contentDidLoad()
                return
            }
            
            confirmationRequestDTO = ConfirmationRequestDTO(
                Language: ServiceConfiguration.Language,
                ProcessType: ServiceConfiguration.ProcessType,
                UserName: confirmationModel.UserName,
                CompanyId: confirmationModel.CompanyId,
                CityId: selectedCity.Id,
                DistrictId: selectedDistrict.Id,
                phoneNumber: phoneNumber,
                SmsCode: "",
                CodeId: 0
            )
        }
        else {
            confirmationRequestDTO = ConfirmationRequestDTO(
                Language: ServiceConfiguration.Language,
                ProcessType: ServiceConfiguration.ProcessType,
                UserName: confirmationModel.UserName,
                CompanyId: confirmationModel.CompanyId,
                CityId: confirmationModel.CityId,
                DistrictId: confirmationModel.DistrictId,
                phoneNumber: phoneNumber,
                SmsCode: "",
                CodeId: 0
            )
        }
        
        guard let confirmationRequestDTO = confirmationRequestDTO else {
            self.baseVMDelegate?.contentDidLoad()
            return
        }
        
        accountRepository.confirmation(confirmationRequestDTO: confirmationRequestDTO) {[weak self] confirmationResponse in
            self?.baseVMDelegate?.contentDidLoad()
            var confirmationRequest: ConfirmationRequestDTO = confirmationRequestDTO
            confirmationRequest.CodeId = confirmationResponse.CodeId
            
            self?.delegate?.navigateToOtpPage(confirmationRequest: confirmationRequest)
        } failure: {[weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            
            self?.delegate?.contentFailed(errorMessage: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
    }
}
