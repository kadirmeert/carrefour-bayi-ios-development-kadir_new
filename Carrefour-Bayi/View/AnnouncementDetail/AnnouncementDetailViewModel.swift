//
//  AnnouncementDetailViewModel.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 12.11.2022.
//

import Foundation

protocol AnnouncementDetailViewModelDelegate: BaseViewModelDelegate {

}

class AnnouncementDetailViewModel: BaseViewModel {
    weak var delegate: AnnouncementDetailViewModelDelegate?
    
    var advertisementData: GetAdvertisementData?
}
