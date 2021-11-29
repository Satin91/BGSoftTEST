//
//  FollowTheLinkProtocol.swift
//  BGSoftTEST
//
//  Created by Артур on 27.11.21.
//

import Foundation

//MARK: Делегат передает ссылку для webView

protocol FollowTheLink {
    func openWebViewController(link: String)
}
