//
//  ProductModel.swift
//  Carrefour-Bayi
//
//  Created by Veysel Bozkurt on 8.12.2022.
//

import Foundation

struct ProductModel: Codable {
    let ProductId: Int?
    let Sube: Int?
    let sto_Guid: String?
    let StokKodu: String?
    let StokAdi: String?
    let sto_perakende_vergi: Int?
    let sto_toptan_vergi: Int?
    let sto_sezon_kodu: String?
    let sto_reyon_kodu: String?
    let ReyonKodu: Int?
    let AnaGrupKodu: Int?
    let AnaHamKodu: Int?
    let MalGrubuKodu: Int?
    let sto_hammadde_kodu: String?
    let Pazartesi: Int?
    let Sali: Int?
    let Carsamba: Int?
    let Persembe: Int?
    let Cuma: Int?
    let Cumartesi: Int?
    let Pazar: Int?
    let sto_satis_dursun: Bool?
    let sto_tasfiyede: Bool?
    let sto_franchise_siparis_dursun: Int?
    let sto_siparis_dursun: Int?
    let sto_birim2_katsayi: Float?
    let sto_karorani: Int?
    let sto_prim_orani: Int?
    let sto_ver_sip_birim: Int?
    let Miktar: Float?
    let Birim: String?
    let Price: Float?
    let SiparisGunleri: String?

}
