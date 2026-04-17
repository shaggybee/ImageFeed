//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 23.02.2026.
//

import WebKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {

    //MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        webView.accessibilityIdentifier = Constants.webViewIdentifier
        
        return webView
    }().forAutoLayout
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        
        progressView.tintColor = .ypBlack
        
        return progressView
    }().forAutoLayout
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        setElements()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Overrides
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    // MARK: - Public methods
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(progressView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
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
        static let webViewIdentifier = "UnsplashWebView"
    }
}
