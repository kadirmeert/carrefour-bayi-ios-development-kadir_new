//
//  AnnouncementDetailViewController.swift
//  Carrefour-Bayi
//
//  Created by Elif Kasapoglu on 12.11.2022.
//

import UIKit
import Alamofire
import JGProgressHUD
import WebKit

protocol AnnouncementDetailViewControllerDelegate {
    func backButtonTappedInAnnouncement()
}
class AnnouncementDetailViewController: BaseViewController {
    
    //    MARK: - Properties -
    var viewModel: AnnouncementDetailViewModel!
    var delegate: AnnouncementDetailViewControllerDelegate?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    //    MARK: - Views -
    @IBOutlet weak var webView: WKWebView!
    

    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHTMLStringImage()
    }
    
    func loadHTMLStringImage() -> Void {
        let htmlString = viewModel.advertisementData?.Description ?? ""
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        delegate?.backButtonTappedInAnnouncement()
    }
}
//    MARK: - AnnouncementDetailViewModelDelegate Methods -
extension AnnouncementDetailViewController: AnnouncementDetailViewModelDelegate {
    
}
//
// MARK: - Creator
extension AnnouncementDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "AnnouncementDetailViewController"
        }
    }
    
    class func create(advertisementData: GetAdvertisementData) -> AnnouncementDetailViewController {
        let vc: AnnouncementDetailViewController = AnnouncementDetailViewController.instantiateFromNib()
        let viewModel: AnnouncementDetailViewModel = AnnouncementDetailViewModel()
        vc.viewModel = viewModel
        vc.viewModel.advertisementData = advertisementData
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        viewModel.delegate = vc
        return vc
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}


extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
