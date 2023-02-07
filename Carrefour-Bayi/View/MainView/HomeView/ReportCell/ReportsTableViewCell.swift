//
//  ReportsTableViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 24.08.2022.
//

import UIKit
import WebKit

class ReportsTableViewCell: UITableViewCell {
    // MARK: -Views
    let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            prefs.allowsContentJavaScript = true
        }
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: -UI Methods
    func bind(url: String) {
        contentView.addSubview(webView)
        
        webView.frame = containerView.frame
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}
