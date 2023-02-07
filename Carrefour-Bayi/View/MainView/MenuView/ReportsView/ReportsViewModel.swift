//
//  ReportsViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 15.09.2022.
//

import Foundation

protocol ReportsViewModelDelegate: BaseViewModelDelegate {
    
}

class ReportsViewModel: BaseViewModel {
    weak var delegate: ReportsViewModelDelegate?
    
    var reportItems: [ReportItem]
    
    init(menuItems: [ReportItem] = []) {
        self.reportItems = [ReportItem(reportTitle: "departmentBasedSales".localized, reportIcon: "icon_right_arrow_shadow", reportItemCode: .departmentBasedSales),
                            ReportItem(reportTitle: "materialStockMovements".localized, reportIcon: "icon_right_arrow_shadow", reportItemCode: .materialStockMovements),
                            ReportItem(reportTitle: "promotionReport".localized, reportIcon: "icon_right_arrow_shadow", reportItemCode: .promotionReport),
                            ReportItem(reportTitle: "salesProfitabilityReport".localized, reportIcon: "icon_right_arrow_shadow", reportItemCode: .salesProfitabilityReport),
                            ReportItem(reportTitle: "stockReport".localized, reportIcon: "icon_right_arrow_shadow", reportItemCode: .stockReport)]
    }
    
    func navigateToReportMenuItem(menuItemCode: ReportAction) {
        switch menuItemCode {
        case .departmentBasedSales:
            print("departmentBasedSales")
        case .materialStockMovements:
            print("materialStockMovements")
        case .promotionReport:
            print("promotionReport")
        case .salesProfitabilityReport:
            print("salesProfitabilityReport")
        case .stockReport:
            print("stockReport")
        }
    }
}
