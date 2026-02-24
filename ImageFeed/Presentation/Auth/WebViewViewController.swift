//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 23.02.2026.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadAuthView()
    }
    
    // MARK: - Private methods
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: NetworkingConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: NetworkingConstants.redirectURI),
            URLQueryItem(name: "response_type", value: Constants.unsplashAuthorizeResponseType),
            URLQueryItem(name: "scope", value: NetworkingConstants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
    
        webView.load(URLRequest(url: url))
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants.unsplashAuthorizeRelativeCodeAddress,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == Constants.unsplashAuthorizeResponseType })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Constants
private extension WebViewViewController {
    enum Constants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let unsplashAuthorizeRelativeCodeAddress = "/oauth/authorize/native"
        static let unsplashAuthorizeResponseType = "code"
    }
}
