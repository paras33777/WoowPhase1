//
//  CustomizeViewController.swift
//  WooW
//
//  Created by Rahul Chopra on 30/05/21.
//

import Foundation
import UIKit
import WebKit

class CustomizeViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    
    func setupWebView(frame: CGRect, url: String) -> WKWebView {
        webView.frame = frame
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    
}
