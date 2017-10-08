//
//  NewsContentVC.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import WebKit

class NewsContentVC: UIViewController, AlertViewControllerProtocol {
    
    private var webView: WKWebView!
    
    var presenter:NewsContentPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        presenter.fetchContentNews { [weak self] (error, result) in
            if let error = error {
                self?.presentAlert(error: error)
            }
            if let htmlString = result {
                self?.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
    }

    private func setupWebView() {
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        
        let height = NSLayoutConstraint(item: webView, attribute:.height, relatedBy:.equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute:.width, relatedBy:.equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
    }

}
