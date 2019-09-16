//
//  RepoDetailsViewController.swift
//  SquareRepos
//
//  Created by Pratima Gauns on 9/16/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import WebKit

//
// View - VC that displays webview with html_url
//
class RepoDetailsViewController: BaseViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.backgroundColor = .red
        return webView
    }()
    
    var htmlUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.leadingAnchor.constraint( equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint( equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        setupHeaderView()
        appBar.navigationBar.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Button.title.cancel", comment: ""), style: .plain, target: self, action: #selector(backClicked))
        
        appBar.headerViewController.headerView.trackingScrollView = webView.scrollView
        
        if let _ = htmlUrl, let urlToLoad = URL(string:htmlUrl!) {
            let request = URLRequest(url: urlToLoad)
            webView.load(request)
        }
    }
    
    @objc
    func backClicked(sender: UITapGestureRecognizer!) {
        dismiss(animated: true, completion: nil)
    }
}
