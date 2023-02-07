//
//  RepositoryProvider.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 25.07.2022.
//

import Foundation

///It is produced for service calls and answers to be used for mock or live environment.
class RepositoryProvider {
    #if MOCK_REPOSITORY
    static let accountRepository: AccountRepository = MockAccountRepository()
    static let cityRepository: CityRepository = MockCityRepository()
    static let tokenRepository: TokenRepository = MockTokenRepository()
    static let sapRepository: SAPRepository = MockSAPRepository()
    static let companyRepository: CompanyRepository = MockCompanyRepository()
    static let reportRepository: ReportRepository = MockReportRepository()
    static let purchaseRequestRepository: PurchaseRequestRepository = MockPurchaseRequestRepository()
    static let orderRepository: OrderRespository = MockOrderRepository()
    static let advertisementRepository: AdvertisementRepository = MockAdvertisementRepository()
    static let regionalManagerRepository: RegionalManagerRepository = MockRegionalManagerRepository()
    static let notificationRepository: NotificationRepository = MockNotificationRepository()
    static let productRepository: ProductRepository = MockProductRepository()
    static let masterPassRepository: MasterPassRepository = MockMasterPassRepository
    #else
    static let accountRepository: AccountRepository = DefaultAccountRepository(tokenRepository: DefaultTokenRepository())
    static let cityRepository: CityRepository = DefaultCityRepository()
    static let tokenRepository: TokenRepository = DefaultTokenRepository()
    static let sapRepository: SAPRepository = DefaultSAPRepository()
    static let companyRepository: CompanyRepository = DefaultCompanyRepository()
    static let reportRepository: ReportRepository = DefaultReportRepository()
    static let purchaseRequestRepository: PurchaseRequestRepository = DefaultPurchaseRequestRepository()
    static let orderRepository: OrderRespository = DefaultOrderRepository()
    static let advertisementRepository: AdvertisementRepository = DefaultAdvertisementRepository()
    static let regionalManagerRepository: RegionalManagerRepository = DefaultRegionalManagerRepository()
    static let notificationRepository: NotificationRepository = DefaultNotificationRepository()
    static let productRepository: ProductRepository = DefaultProductRepository()
    static let masterPassRepository: MasterPassRepository = DefaultMasterPassRepository()
    #endif
}
