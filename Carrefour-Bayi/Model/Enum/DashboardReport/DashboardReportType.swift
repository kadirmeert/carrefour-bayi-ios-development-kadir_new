//
//  DashboardReportType.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import Foundation

enum DashboardReportType: String, Codable {
    case departmentBasedSales = "DepartmanBazliSatis"
    case salesProfitability = "SatisKarlilik"
    case promotionReport = "PromosyonRaporu"
    case materialStockMovements = "MalzemeStokHareketleri"
    case stockReportService = "StokRaporuServisi"
    case storeMonthly = "StoreAylık"
}
