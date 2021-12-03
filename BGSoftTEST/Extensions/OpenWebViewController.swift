//
//  OpenWebViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 27.11.21.
//


import UIKit


//MARK: Открывает WebView

extension MainViewController: FollowTheLink {
    
    func openWebViewController(link: String) {
        let pageVC = WebViewController()
        pageVC.link = link
        present(pageVC, animated: true, completion: nil)
    }
}
