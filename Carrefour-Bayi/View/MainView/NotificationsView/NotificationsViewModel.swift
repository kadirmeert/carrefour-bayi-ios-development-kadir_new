//
//  NotificationsViewModel.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 31.08.2022.
//

import Foundation

protocol NotificationsViewModelDelegate: BaseViewModelDelegate {
    func pageContentSuccess(unreadNotificationCount: Int)
    func pageContentFailed(message: String)
}

class NotificationsViewModel: BaseViewModel {
    weak var delegate: NotificationsViewModelDelegate?
    
    private var notificationRepository: NotificationRepository
    var notificationModel: GetAllNotificationResponseDTO?
    
    
    init(notificationRepository: NotificationRepository = RepositoryProvider.notificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    
    override func viewWillAppear() {
        getAllNotifications()
    }
    
    
    func getAllNotifications() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.baseVMDelegate?.contentWillLoad()
        }
        notificationRepository.getAllNotification { [weak self] notificationResponseDTO in
            self?.notificationModel = notificationResponseDTO
            let notificationCount = self?.calculateUnreadNotificationCount()
            self?.delegate?.pageContentSuccess(unreadNotificationCount: notificationCount ?? 0)
            self?.baseVMDelegate?.contentDidLoad()
        } failure: { [weak self] errorDTO in
            self?.delegate?.pageContentFailed(message: errorDTO?.messageText ?? "generalErrorMessage".localized)
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func calculateUnreadNotificationCount() -> Int {
        if let notificationData = self.notificationModel?.Notifications {
            var unreadNotificationCount = 0
            notificationData.forEach { notification in
                if !(notification.IsRead ?? false) {
                    unreadNotificationCount += 1
                }
            }
            return unreadNotificationCount
        } else {
            return 0
        }
    }
    
    
    func markNotificationAsRead(notificationID: Int?) {
        if let notificationID = notificationID {
            notificationRepository.notificationMarkAsRead(notificationId: notificationID) { _ in
                let notificationCount = self.calculateUnreadNotificationCount()
                self.delegate?.pageContentSuccess(unreadNotificationCount: notificationCount ?? 0)
            } failure: { errorDTO in
            }
        }
    }
}
