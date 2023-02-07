//
//  GetStoreDashboardDetailResponseDTO.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 6.09.2022.
//

import Foundation

struct GetStoreDashboardDetailResponseDTO: Codable, BaseResponse {
    var Success: Bool?
    var Message: String?
    let SAP: Int?
    let Cari: String?
    let TeminatMektubu: Double?
    let AcikSiparisToplami: Double?
    let VadesiGecmisTutar: Double?
    let ToplamBorc: Double?
    let TeminatiAsanTutar: Double?
    let OdenecekTutar: Double?
    let ToplamSupurmeliPOS: Double?
    let ToplamLimit: Double?
    let KullanilmisLimit: Double?
    let KalanLimit: Double?
}
