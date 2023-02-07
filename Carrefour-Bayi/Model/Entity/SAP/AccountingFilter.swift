//
//  AccountingFilter.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import Foundation

struct AccountingFilter: Codable {
    let Name: String?
    let InvoiceDescription: String?
    let ReferenceNo: String?
    let DocumentNo: String?
    let Designation: String?
    let DocumentType: String?
    let FirstDate: String?
    let LastDate: String?
    let FirstInvoiceDate: String?
    let LastInvoiceDate: String?
    let DebtOperator: String?
    let Debt: Int?
    let ReceivableOperator: String?
    let Receivable: Int?
    let BalanceOperator: String?
    let Balance: Int?
}
