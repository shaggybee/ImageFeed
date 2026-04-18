//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
