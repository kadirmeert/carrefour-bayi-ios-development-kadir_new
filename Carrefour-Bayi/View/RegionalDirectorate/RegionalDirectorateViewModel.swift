//
//  RegionalDirectorateViewModel.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 13.11.2022.
//

import Foundation
import UIKit

protocol RegionalDirectorateViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess()
    func managerTransactionSuccess(message: String)
    func pageContentFailed(message: String)
}

class RegionalDirectorateViewModel: BaseViewModel {
    weak var delegate: RegionalDirectorateViewModelDelegate?
    
    private var regionalManagerRepository: RegionalManagerRepository
    var regionalManagerModel: GetRegionalManagerResponseDTO?
    var selectedManager: RegionalManagerData?
    
    var sections: [AllRegionalManagerSection] = []
    
    init(regionalManagerRepository: RegionalManagerRepository = RepositoryProvider.regionalManagerRepository) {
        self.regionalManagerRepository = regionalManagerRepository
    }
    
    override func viewWillAppear() {
        getRegionalManagers()
    }
    
    func getRegionalManagers() {
        baseVMDelegate?.contentWillLoad()
        let getRegionalManagerRequestDTO: GetRegionalManagerRequestDTO = GetRegionalManagerRequestDTO(CurrentPage: 1, Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType, RecordSizeFromPage: 100, SortColumn: "Id", SortColumnAscDesc: "Desc", Filter: RegionalManagerFilter(EMailAdress: nil, SAP: nil, StoreName: nil))
        
       regionalManagerRepository.getRegionalManager(requestDTO: getRegionalManagerRequestDTO) { [weak self] getRegionalManagerResponse in
           self?.baseVMDelegate?.contentDidLoad()
           self?.regionalManagerModel = getRegionalManagerResponse
           if let managerData = self?.regionalManagerModel {
               if let managers = managerData.RegionalManagers {
                   self?.sections.removeAll()
                    
                   if managers.count > 0 {
                       self?.sections = managers.map({ data in
                           return AllRegionalManagerSection(regionalManagerData: data)
                       })
                   } else {
                       self?.delegate?.pageContentFailed(message: managerData.Message ?? "generalErrorMessage".localized)
                   }
               }
           }
            
           self?.delegate?.pageContentSuccess()
        } failure: { [weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
        
    }
    
    func getFilteredRegionalManagers(emailAdress: String?, SAP: String?, storeName: String?) {
        baseVMDelegate?.contentWillLoad()
        let getFilteredManagerRequestDTO = GetRegionalManagerRequestDTO(CurrentPage: 1, Language: ServiceConfiguration.Language,
                                                                        ProcessType: ServiceConfiguration.ProcessType,
                                                                        RecordSizeFromPage: 100, SortColumn: "Id",
                                                                        SortColumnAscDesc: "Desc",
                                                                        Filter: RegionalManagerFilter(EMailAdress: emailAdress,
                                                                                                      SAP: SAP,
                                                                                                      StoreName: storeName))
        regionalManagerRepository.getRegionalManager(requestDTO: getFilteredManagerRequestDTO) { [weak self] filteredManagerResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.regionalManagerModel = filteredManagerResponse
            
            if let managerData = self?.regionalManagerModel {
                if let managers = managerData.RegionalManagers {
                    self?.sections.removeAll()
                    
                    if managers.count > 0 {
                        self?.sections = managers.map({ data in
                            return AllRegionalManagerSection(regionalManagerData: data)
                        })
                    } else {
                        self?.delegate?.pageContentFailed(message: managerData.Message ?? "generalErrorMessage".localized)
                    }
                }
            }
            
            self?.delegate?.pageContentSuccess()
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func deleteRegionalManager(regionalManagerId: Int) {
        baseVMDelegate?.contentWillLoad()
        
        let deleteRegionalManagerRequestDTO: DeleteRegionalManagerRequestDTO = DeleteRegionalManagerRequestDTO(RegionalManagerId: regionalManagerId, ProcessType: ServiceConfiguration.ProcessType, Language: ServiceConfiguration.Language)
        
        regionalManagerRepository.deleteRegionalManager(requestDTO: deleteRegionalManagerRequestDTO) { [weak self] deleteResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.managerTransactionSuccess(message: deleteResponse.Message ?? "generalErrorMessage".localized)
            } failure: { [weak self] errorDTO in
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
                self?.baseVMDelegate?.contentDidLoad()
            }
    }
    
    func getTokenForDownloadExcelTemplate() {
        baseVMDelegate?.contentWillLoad()
        
        let getTokenRequest: BaseRequestDTO = BaseRequestDTO(Language: ServiceConfiguration.Language, ProcessType: ServiceConfiguration.ProcessType)
        
        regionalManagerRepository.getTokenForDownloadExcelTemplate(requestDTO: getTokenRequest) { [weak self] tokenResponse in
            self?.baseVMDelegate?.contentDidLoad()
            
            if let url = URL(string: "\(ServiceConfiguration.apiBaseURL)/api/Download/DownloadFile/\(tokenResponse.Token ?? "")") {
                UIApplication.shared.open(url)
            }
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }

    }
    
    func getTokenForRegionalManagersDownloadExcel() {
        baseVMDelegate?.contentWillLoad()
        
        let getTokenRequest = GetTokenForRegionalManagersDownloadExcelRequestDTO(CurrentPage: 1, Language: ServiceConfiguration.Language,
                                                                                 ProcessType: ServiceConfiguration.ProcessType,
                                                                                 RecordSizeFromPage: 100, SortColumn: "Id",
                                                                                 SortColumnAscDesc: "Desc",
                                                                                 Filter: RegionalManagerFilter(EMailAdress: nil,
                                                                                                               SAP: nil,
                                                                                                               StoreName: nil))
        regionalManagerRepository.getTokenForRegionalManagerDownloadExcel(requestDTO: getTokenRequest) { [weak self] tokenResponse in
            self?.baseVMDelegate?.contentDidLoad()
            
            if let url = URL(string: "\(ServiceConfiguration.apiBaseURL)/api/Download/DownloadFile/\(tokenResponse.Token ?? "")") {
                UIApplication.shared.open(url)
            }
            
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func importRegionalManagers(url: URL) {
        baseVMDelegate?.contentWillLoad()
        
        regionalManagerRepository.importRegionalManager(url: url) { [weak self] importResponse in
            self?.baseVMDelegate?.contentDidLoad()
            
            self?.delegate?.managerTransactionSuccess(message: importResponse.Message ?? "Başarıyla yüklendi.")
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
}
