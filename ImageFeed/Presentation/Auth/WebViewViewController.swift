//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 23.02.2026.
//

import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    //MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadAuthView()
        updateProgress()
    }
    
    // MARK: - Overrides
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?)
    {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
         super.observeValue(
            forKeyPath: keyPath,
            of: object,
            change: change,
            context: context)
        }
    }
    
    // MARK: - Private methods
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: AuthorizationConstants.authorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: AuthorizationConstants.QueryItem.clientId, value: AuthorizationConstants.accessKey),
            URLQueryItem(name: AuthorizationConstants.QueryItem.redirectUri, value: AuthorizationConstants.redirectURI),
            URLQueryItem(name: AuthorizationConstants.QueryItem.responseType, value: AuthorizationConstants.QueryItemValue.code),
            URLQueryItem(name: AuthorizationConstants.QueryItem.scope, value: AuthorizationConstants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
    
        webView.load(URLRequest(url: url))
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == AuthorizationConstants.authorizeRelativeCodeAddress,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == AuthorizationConstants.QueryItemValue.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func updateProgress() {
        let estimatedProgress = webView.estimatedProgress
        
        progressView.progress = Float(estimatedProgress)
        progressView.isHidden = fabs(estimatedProgress - Constants.maxProgress) <= Constants.precisionOfProgressCompare
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
        static let precisionOfProgressCompare = 0.0001
        static let maxProgress = 1.0
    }
}
