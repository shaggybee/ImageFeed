//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 24.02.2026.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
