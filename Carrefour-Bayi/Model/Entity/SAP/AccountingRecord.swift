//
//  Record.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 7.09.2022.
//

import Foundation

struct AccountingRecord: Codable {
    let Name: String?
    let InvoiceDescription: String?
    let ReferenceNo: String?
    let DocumentNo: String?
    let Designation: String?
    let DocumentType: String?
    let Date: String?
    let InvoiceDate: String?
    let Debt: Double?
    let Receivable: Double?
    let Balance: Double?
}
