//
//  NotificationsViewController.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 31.08.2022.
//

import UIKit

class NotificationsViewController: BaseViewController {
    // MARK: -Properties
    var viewModel: NotificationsViewModel!
    
    // MARK: -Views
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var unreadNotificationCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: -UI Methods
    private func initUI() {
        NotificationTableViewCell.registerSelf(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        unreadNotificationCountLabel.text = "\(unreadNotifications.count)"
    }
}

// MARK: -UITableViewDelegate & UITableViewDataSource Methods
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notifications = viewModel.notificationModel?.Notifications {
            return notifications.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        if let notifications = viewModel.notificationModel?.Notifications {
            cell.bind(notificationModel: notifications[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let notifications = viewModel.notificationModel?.Notifications {
            if viewModel.notificationModel?.Notifications![indexPath.row].IsRead == false {
                viewModel.notificationModel?.Notifications![indexPath.row].IsRead?.toggle()
                tableView.reloadRows(at: [indexPath], with: .fade)
                viewModel.markNotificationAsRead(notificationID: notifications[indexPath.row].Id)
            }
        }
    }
}

// MARK: -NotificationsViewModelDelegate Methods
extension NotificationsViewController: NotificationsViewModelDelegate {
    func pageContentSuccess(unreadNotificationCount: Int) {
        unreadNotificationCountLabel.text = "\(unreadNotificationCount)"
        tableView.reloadData()
    }
    
    func pageContentFailed(message: String) {
        showErrorAlert(message: message)
    }
}

// MARK: - Creator
extension NotificationsViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "NotificationsViewController"
        }
    }
    
    class func create() -> NotificationsViewController {
        let vc: NotificationsViewController = NotificationsViewController.instantiateFromNib()
        let viewModel: NotificationsViewModel = NotificationsViewModel()
        vc.viewModel = viewModel
        viewModel.delegate = vc
        
        return vc
    }
}
