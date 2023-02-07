//
//  PaymentViewModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 19.12.2022.
//

import Foundation


protocol PaymentViewModelDelegate: BaseViewModelDelegate {
    func getCardsSuccess()
    func callValidateTransaction3D(mfsResponse: MfsResponse)
    func validateTransaction3DWillFinish()
    func callValidateTransaction()
    func processCompleted(message: String)
    func paymentSuccessfullyCompleted()
    func pageContentFailed(message: String)
    func reloadPage()
}

typealias MasterPass = MfsIOSLibrary
class PaymentViewModel: BaseViewModel {
    
    weak var delegate: PaymentViewModelDelegate?
    
    var masterpassRepository: MasterPassRepository
    var tokenRepository: TokenRepository
    var currentCompanyAndStore: CurrentCompanyAndStore?
    
    var masterPassInfoResponseModel: GetMasterPassInfoResponseDTO?
    var masterPassTokenResponseModel: GetMasterPassTokenResponseDTO?
    
    var phoneNumber: String
    var masterPass = MasterPass()
    var registeredCards: [MfsCard]?
    var currentCard: MfsCard?
    var actionResultTokenForInsertResponse: String?
    var currentMethodType = MasterPassMethodType.purchase
    var checkMasterPassResult: MfsResponse?
    var directPurchaseWithRegisterResponseToken: String?
    
    var commitPurchaseNumberOfCalls = 0
    
    
    
    init(masterPassRepository: MasterPassRepository = RepositoryProvider.masterPassRepository,
         tokenRepository: TokenRepository = RepositoryProvider.tokenRepository) {
        self.masterpassRepository = masterPassRepository
        self.tokenRepository = tokenRepository
        self.phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? ""
        self.phoneNumber = tokenRepository.getUserPhoneNumber() ?? ""
    }
    
    
    
    override func viewWillAppear() {
        if let companyCode = currentCompanyAndStore?.companyCode, phoneNumber != ""  {
            getMasterPassToken(reqRefNumber: companyCode, phoneNumber: phoneNumber)
        }
    }
    
    
    //    MARK: - Get Masterpass Token
    /// reqRefNumber olarak --companyCode-- verilmelidir
    private func getMasterPassToken(reqRefNumber: String, phoneNumber: String) {
        baseVMDelegate?.contentWillLoad()
        let requestModel: GetMasterPassTokenRequestDTO = GetMasterPassTokenRequestDTO(Language: ServiceConfiguration.Language,
                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                      Mode: ServiceConfiguration.MasterPassMode,
                                                                                      reqRefNumber: reqRefNumber,
                                                                                      PhoneNumber: phoneNumber)
        
        masterpassRepository.getToken(requestModel: requestModel) { [weak self] tokenResponse in
            self?.baseVMDelegate?.contentDidLoad()
            self?.masterPassTokenResponseModel = tokenResponse
            self?.getMasterPassInfo()
        } failure: { [weak self] errorDTO in
            self?.baseVMDelegate?.contentDidLoad()
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
        }
    }
    
    
    
    
    //    MARK: - Get Masterpass Info
    /// Get MasterPass user infos from backend
    private func getMasterPassInfo() {
        if let companyCode = currentCompanyAndStore?.companyCode {
            baseVMDelegate?.contentWillLoad()
            let requestModel: GetMasterPassInfoRequestDTO = GetMasterPassInfoRequestDTO(Language: ServiceConfiguration.Language,
                                                                                        ProcessType: ServiceConfiguration.ProcessType,
                                                                                        Mode: ServiceConfiguration.MasterPassMode,
                                                                                        CompanyCode: companyCode)
            
            masterpassRepository.getMasterPassInfo(requestModel: requestModel) { [weak self] infoResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.masterPassInfoResponseModel = infoResponse
                self?.initMasterPass()
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            }
        }
    }
    
    
    
    
    
    //    MARK: - Insert Purchase
    /// Pay with registered card
    func insertPurchase(cardName: String, amount: String) {
        baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, let reqRefNo = masterPassInfoResponseModel?.reqRefNumber,
           let macroMerchantID = masterPassInfoResponseModel?.MacroMerchantId {

            let requestModel: InsertPurchaseRequestDTO = InsertPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                  ProcessType: ServiceConfiguration.ProcessType,
                                                                                  UserId: 4,
                                                                                  msisdn: "90\(phoneNumber)",
                                                                                  listAccountName: cardName,
                                                                                  Amount: amount,
                                                                                  reqRefNumber: reqRefNo,
                                                                                  Token: token,
                                                                                  sendSmsLanguage: "tur",
                                                                                  macroMerchantId: macroMerchantID,
                                                                                  sendSms: "",
                                                                                  FullResponse: "")
            
            masterpassRepository.insertPurchase(requestModel: requestModel) { [weak self] insertPurchaseResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.payWithCardName(cardName: cardName, amount: amount)
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
#if DEBUG
                print("VEYSEL <<<< işlem başarısız Insert Purchase -> ", errorDTO ?? "")
#endif
            }
        }
    }
    
    
    
    
    
    
    //    MARK: - Insert Direct Purchase
    /// Payment direct purchase without saving card
    func insertDirectPurchase(expirationDate: String, amount: String, mfsCard: MfsCard,
                              mfsTextField: MfsTextField, mfsCVV: MfsTextField) {
        baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, let reqRefNo = masterPassInfoResponseModel?.reqRefNumber,
           let macroMerchantID = masterPassInfoResponseModel?.MacroMerchantId {
            let requestModel: InsertDirectPurchaseRequestDTO = InsertDirectPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                              ProcessType: ServiceConfiguration.ProcessType,
                                                                                              UserId: 4,
                                                                                              msisdn: "90" + self.phoneNumber,
                                                                                              CardNumberMasked: "",
                                                                                              ExpirationDate: expirationDate,
                                                                                              CardHolderName: mfsCard.cardHolderName ?? "",
                                                                                              Amount: amount,
                                                                                              reqRefNumber: reqRefNo,
                                                                                              Token: token,
                                                                                              sendSmsLanguage: "tur",
                                                                                              macroMerchantId: macroMerchantID,
                                                                                              sendSms: "",
                                                                                              FullResponse: "")
            
            masterpassRepository.insertDirectPurchase(requestModel: requestModel) { [weak self] insertDirectPurchaseResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.directPurchase(mfsCard: mfsCard, amount: amount, mfsTextField: mfsTextField, mfsCVV: mfsCVV, orderNo: reqRefNo)
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
#if DEBUG
                print("VEYSEL <<<< işlem başarısız Insert Direct Purchase -> ", errorDTO ?? "")
#endif
            }
        }
    }
    
    
    
    
    //    MARK: - Insert Register Purchase
    /// Payment direct purchase with saving card
    func insertRegisterPurchase(expirationDate: String, amount: String, mfsCard: MfsCard,
                                mfsTextField: MfsTextField, mfsCVV: MfsTextField, mfsCheckBox: MfsCheckbox) {
        baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, let reqRefNo = masterPassInfoResponseModel?.reqRefNumber,
           let macroMerchantID = masterPassInfoResponseModel?.MacroMerchantId {
            let requestModel: InsertRegisterPurchaseRequestDTO = InsertRegisterPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                  ProcessType: ServiceConfiguration.ProcessType,
                                                                                                  UserId: 4,
                                                                                                  msisdn: "90" + self.phoneNumber,
                                                                                                  CardRegistryName: mfsCard.cardName,
                                                                                                  CardNumberMasked: "",
                                                                                                  ExpirationDate: expirationDate,
                                                                                                  CardHolderName: mfsCard.cardHolderName,
                                                                                                  Amount: amount,
                                                                                                  reqRefNumber: reqRefNo,
                                                                                                  Token: token,
                                                                                                  sendSmsLanguage: "tur",
                                                                                                  macroMerchantId: macroMerchantID,
                                                                                                  sendSms: "",
                                                                                                  FullResponse: "")
            
            masterpassRepository.insertRegisterPurchase(requestModel: requestModel) { [weak self] registerPurchaseResponse in
                self?.baseVMDelegate?.contentDidLoad()
                self?.directPurchaseWithRegister(mfsCard: mfsCard, amount: amount, mfsTextfield: mfsTextField,
                                                 cvvTextField: mfsCVV, checkbox: mfsCheckBox)
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
#if DEBUG
                print("VEYSEL <<<< işlem başarısız Insert Register Purchase -> ", errorDTO ?? "")
#endif
            }
        }
        
    }
    
    
    
    
    
    //    MARK: - Commit Purchase
    /// Send purchase to backend
    func commitPurchase() {
        baseVMDelegate?.contentWillLoad()
        if let reqRefNumber = masterPassInfoResponseModel?.reqRefNumber {
            let requestModel: MasterPassCommitPurchaseRequestDTO = MasterPassCommitPurchaseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                                      Mode: ServiceConfiguration.MasterPassMode,
                                                                                                      reqRefNumber: reqRefNumber,
                                                                                                      token: "")
            
            masterpassRepository.commitPurchase(requestModel: requestModel) { [weak self] commitResponse in
                self?.baseVMDelegate?.contentDidLoad()
                if self?.currentMethodType == .directPurchase {
                    self?.delegate?.paymentSuccessfullyCompleted()
                    self?.delegate?.reloadPage()
                } else if self?.currentMethodType == .registerPurchase {
                    // Ödeme tamamlandı diye uyarı göster ve kart kaydetme adımına geç
                    // Complete registration çağırılacak
                    if let currentCard = self?.currentCard {
                        self?.completeRegistration(cardName: currentCard.cardName)
                    }
                } else {
                    self?.delegate?.paymentSuccessfullyCompleted()
                    self?.delegate?.reloadPage()
                }
#if DEBUG
                print("VEYSEL <<<< işlem commit Purchase tamam  -> ")
#endif
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.commitPurchaseNumberOfCalls += 1
                    if self!.commitPurchaseNumberOfCalls < 25 {
                        self?.commitPurchase()
                    } else {
                        self?.delegate?.pageContentFailed(message: "Ödeme tamamlanamadı.")
                        self?.commitPurchaseNumberOfCalls = 0
                    }
                }
#if DEBUG
                print("VEYSEL <<<< işlem başarısız Commit Purchase -> ", errorDTO ?? "")
#endif
            }
        }
    }
    
    
    
    
    
    //    MARK: - Insert Response
    func insertResponse(requestName: String, token: String) {
        baseVMDelegate?.contentWillLoad()
        let fullResponse = self.fullResponse(token: token)
        if let token = masterPassTokenResponseModel?.token, let reqRefNo = masterPassInfoResponseModel?.reqRefNumber {
            let requestModel: MasterPassInsertResponseRequestDTO = MasterPassInsertResponseRequestDTO(Language: ServiceConfiguration.Language,
                                                                                                      ProcessType: ServiceConfiguration.ProcessType,
                                                                                                      RequestName: requestName,
                                                                                                      reqRefNumber: reqRefNo,
                                                                                                      responseCode: "",
                                                                                                      FullResponse: fullResponse,
                                                                                                      Token: token,
                                                                                                      url3D: "")
            
            masterpassRepository.insertResponse(requestModel: requestModel) { [weak self] insertResponse in
                self?.baseVMDelegate?.contentDidLoad()
#if DEBUG
                print("VEYSEL <<<< işlem başarılı Insert Response -> ", insertResponse)
#endif
            } failure: { [weak self] errorDTO in
                self?.baseVMDelegate?.contentDidLoad()
                self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
#if DEBUG
                print("VEYSEL <<<< işlem başarısız Insert Response -> ", errorDTO ?? "")
#endif
            }
        }
    }
}





































































//    MARK: - MASTERPASS METHODS -
extension PaymentViewModel {
    private func initMasterPass() {
        if let clientID = masterPassInfoResponseModel?.clientId,
           let macroMerchantID = masterPassInfoResponseModel?.MacroMerchantId,
           let returnURL = masterPassInfoResponseModel?.returnUrl,
           let clientSetAddress = masterPassInfoResponseModel?.ClientSetAddress {
            self.masterPass = MasterPass(msisdn: "90" + self.phoneNumber)
            self.masterPass.clientId = clientID
            self.masterPass.macroMerchantId = macroMerchantID
            self.masterPass.language = "tur"
            self.masterPass.resultUrl3D = returnURL + "Mobil"
            self.masterPass.baseURL = clientSetAddress
            self.masterPass.msisdn = "90" + self.phoneNumber
            checkMasterPass()
        }
    }
    
    
    
    
    
    
    //    MARK: - Check MasterPass
    func checkMasterPass() {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, phoneNumber != "" {
            masterPass.checkMasterPassEndUser("90\(phoneNumber)", token: token,
                                              checkCallback: #selector(checkMasterPassCallback(_ :)),
                                              checkTarget: self)
        }
    }
    
    @objc
    private func checkMasterPassCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        self.checkMasterPassResult = actionResult
        if actionResult.result {
            if let status = actionResult.cardStatus {
                if status[2] == "1" {
                    getCards()
                } else {
                    linkCardToClient()
                }
            }
            print("VEYSEL <<<< işlem başarılı check masterpass", actionResult.cardStatus as Any)
        } else {
            self.delegate?.pageContentFailed(message: actionResult.errorDescription)
        }
    }
    
    
    
    
    
    
    //    MARK: - Link Card to Client
    func linkCardToClient() {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, phoneNumber != "" {
            masterPass.linkCard(toClient: "90\(phoneNumber)", token: token, cardName: nil,
                                linkCallback: #selector(linkCardToClientCallback(_ :)), linkTarget: self)
            currentMethodType = .linkCardToClient
        }
    }
    
    @objc
    private func linkCardToClientCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            getCards()
#if DEBUG
            print("VEYSEL <<<< işlem başarılı link card to client -> ")
#endif
        } else {
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTPDevice_5007.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTPTelNo_5008.rawValue {
                self.delegate?.callValidateTransaction()
            }
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Get Cards
    /// Get registered cards for customer
    func getCards() {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token {
            masterPass.getCards(#selector(getCardsCallback(_ :)), token: token, getCardsTarget: self)
        }
    }
    
    @objc
    private func getCardsCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            if let cardList = actionResult.cardList as? [MfsCard] {
                self.registeredCards = cardList
            }
            self.delegate?.getCardsSuccess()
#if DEBUG
            print("VEYSEL <<<< işlem başarılı get cards -> ", registeredCards as Any)
#endif
        } else {
            self.delegate?.getCardsSuccess()
#if DEBUG
            print("VEYSEL <<<< işlem başarısız get cards -> ", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Pay with Card Name
    func payWithCardName(cardName: String, amount: String) {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token, let orderID = masterPassInfoResponseModel?.reqRefNumber {
            masterPass.pay(cardName, token: token, amount: amount, cvv: nil, orderId: orderID,
                           payCallback: #selector(payWithCardNameCallback(_ :)), payTarget: self)
            currentMethodType = .purchase
        } else {
            self.delegate?.pageContentFailed(message: "generalErrorMessage".localized)
        }
    }
    
    @objc
    private func payWithCardNameCallback(_ actionResult: MfsResponse) {
        if actionResult.result {
            commitPurchase()
#if DEBUG
            print("VEYSEL <<<< işlem başarılı Pay with Card")
#endif
        } else {
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTP_3D_5010.rawValue {
                self.delegate?.callValidateTransaction3D(mfsResponse: actionResult)
            } else if actionResult.errorCode == MasterPassErrorCode.MPIN_5002.rawValue {
                
            } else {
                self.delegate?.pageContentFailed(message: actionResult.errorDescription)
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarısız Pay with Card", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Delete Card
    func deleteCard(cardName: String) {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token {
            masterPass.deleteCard(cardName, token: token,
                                  deleteCallback: #selector(deleteCardCallback(_:)), deleteTarget: self)
        } else {
            self.delegate?.pageContentFailed(message: "generalErrorMessage".localized)
        }
    }
    
    @objc
    private func deleteCardCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            getCards()
            self.delegate?.processCompleted(message: "Kart başarıyla silindi.")
#if DEBUG
            print("VEYSEL <<<< işlem başarılı delete card")
#endif
        } else {
            self.delegate?.pageContentFailed(message: actionResult.errorDescription)
#if DEBUG
            print("VEYSEL <<<< işlem başarısız delete card", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Direct Purchase
    func directPurchase(mfsCard: MfsCard, amount: String, mfsTextField: MfsTextField, mfsCVV: MfsTextField, orderNo: String) {
        self.baseVMDelegate?.contentWillLoad()
        if let token = masterPassTokenResponseModel?.token {
            masterPass.directPurchase(mfsCard, token: token, amount: amount, textField: mfsTextField, cvv: mfsCVV, orderNo: orderNo,
                                      directPurchaseCallback: #selector(directPurchaseCallback(_ :)),
                                      directPurchaseTarget: self)
            currentMethodType = .directPurchase
        } else {
            self.delegate?.pageContentFailed(message: "generalErrorMessage".localized)
        }
    }
    
    @objc
    private func directPurchaseCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            commitPurchase()
#if DEBUG
            print("VEYSEL <<<< işlem başarılı direct Purchase", actionResult.result, actionResult)
#endif
        } else {
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTP_3D_5010.rawValue {
                self.delegate?.callValidateTransaction3D(mfsResponse: actionResult)
            } else {
                self.delegate?.pageContentFailed(message: actionResult.errorDescription)
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarısız direct Purchase", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Direct Purchase With Register
    func directPurchaseWithRegister(mfsCard: MfsCard, amount: String,
                                    mfsTextfield: MfsTextField, cvvTextField: MfsTextField, checkbox: MfsCheckbox) {
        self.baseVMDelegate?.contentWillLoad()
        masterPass.directPurchase(mfsCard, token: self.masterPassTokenResponseModel?.token,
                                  amount: amount, textField: mfsTextfield, cvv: cvvTextField,
                                  orderNo: self.masterPassInfoResponseModel?.reqRefNumber,
                                  checkbox: checkbox, directPurchaseCallback: #selector(directPurchaseWithRegisterCallback(_ :)),
                                  directPurchaseTarget: self)
        currentMethodType = .registerPurchase
    }
    
    @objc
    private func directPurchaseWithRegisterCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            directPurchaseWithRegisterResponseToken = actionResult.token
#if DEBUG
            print("VEYSEL <<<< işlem başarılı direct Purchase with Register", actionResult)
#endif
        } else {
            directPurchaseWithRegisterResponseToken = actionResult.token
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTP_3D_5010.rawValue {
                delegate?.callValidateTransaction3D(mfsResponse: actionResult)
            } else {
                self.delegate?.pageContentFailed(message: actionResult.errorDescription)
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarısız direct Purchase with Register", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - Complete Registration
    func completeRegistration(cardName: String) {
        self.baseVMDelegate?.contentWillLoad()
        let token = directPurchaseWithRegisterResponseToken
        if let serverToken = masterPassTokenResponseModel?.token {
            masterPass.completeRegistration(serverToken, token2: token,
                                            cardName: cardName,
                                            completeRegistrationCallback: #selector(completeRegistrationCallback(_ :)),
                                            completeRegistrationTarget: self)
            currentMethodType = .completeRegistration
        } else {
            self.delegate?.pageContentFailed(message: "Kart Kaydedilemedi!")
        }
        
    }
    
    @objc
    private func completeRegistrationCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
#if DEBUG
            print("VEYSEL <<<< işlem başarılı Complete Registration", actionResult)
#endif
                self.delegate?.reloadPage()
        } else {
            directPurchaseWithRegisterResponseToken = actionResult.token
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTPDevice_5007.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTPTelNo_5008.rawValue {
                self.delegate?.callValidateTransaction()
#if DEBUG
                print("VEYSEL <<<< işlem 5008 e girdi -> ")
#endif
            } else if actionResult.errorCode == MasterPassErrorCode.PIN_5015.rawValue {
                
            } else {
                self.delegate?.pageContentFailed(message: actionResult.errorDescription)
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarısız Complete Registration", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    
    //    MARK: - Validate Transaction
    func validateTransaction(mfsTextField: MfsTextField) {
        self.baseVMDelegate?.contentWillLoad()
        if let token = directPurchaseWithRegisterResponseToken {
            masterPass.validateTransaction(token, textField: mfsTextField,
                                           validateTransactionCallback: #selector(validateTransactionCallback(_ :)),
                                           validateTransactionTarget: self)
        } else {
            self.delegate?.pageContentFailed(message: "generalErrorMessage".localized)
        }
    }
    
    @objc
    private func validateTransactionCallback(_ actionResult: MfsResponse) {
        self.baseVMDelegate?.contentDidLoad()
        if actionResult.result {
            if currentMethodType != .completeRegistration && currentMethodType != .linkCardToClient {
                commitPurchase()
            } else {
                self.delegate?.reloadPage()
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarılı validate Transaction", actionResult.result, actionResult)
#endif
        } else {
            if actionResult.errorCode == MasterPassErrorCode.OTP_5001.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTP_3D_5010.rawValue {
                self.delegate?.callValidateTransaction3D(mfsResponse: actionResult)
            } else if actionResult.errorCode == MasterPassErrorCode.OTPDevice_5007.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.OTPTelNo_5008.rawValue {
                self.delegate?.callValidateTransaction()
            } else if actionResult.errorCode == MasterPassErrorCode.PIN_5015.rawValue {
                
            } else if actionResult.errorCode == MasterPassErrorCode.MPIN_5002.rawValue {
                
            } else {
                self.delegate?.pageContentFailed(message: actionResult.errorDescription)
            }
#if DEBUG
            print("VEYSEL <<<< işlem başarısız validate Transaction", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
    
    
    
    
    
    
    
    //    MARK: - 3D Validate Transaction
    func validateTransaction3D(mfsWebView: MfsWebView, mfsResponse: MfsResponse) {
        self.actionResultTokenForInsertResponse = mfsResponse.token
        masterPass.validateTransaction3D(mfsWebView, response: mfsResponse,
                                         validateCallback: #selector(validateTransaction3DCallback(_ :)), validateTarget: self)
    }
    
    @objc
    private func validateTransaction3DCallback(_ actionResult: MfsResponse) {
        if actionResult.result {
            if let token = self.actionResultTokenForInsertResponse {
                insertResponse(requestName: currentMethodType.rawValue, token: token)
            }
            commitPurchase()
            self.delegate?.validateTransaction3DWillFinish()
#if DEBUG
            print("VEYSEL <<<< işlem başarılı 3D validate Transaction", actionResult.result, actionResult.errorDescription!)
#endif
        } else {
            self.delegate?.validateTransaction3DWillFinish()
            self.delegate?.pageContentFailed(message: actionResult.errorDescription)
#if DEBUG
            print("VEYSEL <<<< işlem başarısız 3D validate Transaction", String(actionResult.errorCode), String(actionResult.errorDescription))
#endif
        }
    }
}


























/// Return full response for backend
extension PaymentViewModel {
    private func fullResponse(token: String) -> String {
        return "{\"referenceNo\":\"500355345941\",\"responseCode\":\"5010\",\"responseDescription\":\"3D Secure Payment is required.\",\"url3D\":\"\(token)\",\"url3DSuccess\":\"https://uatjs.masterpassturkiye.com/RedirectServer/JsonMMIUIMasterPass_LB_V2/s3d/client/success\",\"url3DError\":\"https://uatjs.masterpassturkiye.com/RedirectServer/JsonMMIUIMasterPass_LB_V2/s3d/client/error\",\"newMsisdn\":\"\",\"internalResponseCode\":\"\",\"internalResponseDescription\":\"\",\"token\":\"\",\"transactionId\":\"500355345941\",\"cardUniqueId\":\"\"}"
    }
}
