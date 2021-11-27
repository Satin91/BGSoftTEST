//
//  PageViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 27.11.21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView = WKWebView()
    var link: String?
    func setupWebView() {
        webView.frame = view.bounds
        view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        guard let link = link else { return }
        guard let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    


}
