//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 23.02.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Private properties
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    // MARK: - Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != Constants.showWebViewSegueIdentifier {
            super.prepare(for: segue, sender: sender)
            
            return
        }
        
        if let destinationViewController = segue.destination as? WebViewViewController {
            destinationViewController.delegate = self
        } else {
            assertionFailure("Failed to prepare for \(Constants.showWebViewSegueIdentifier)")
        }
    }
    
    // MARK: - Private methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .backward)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .backward)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        OAuth2Service.shared.fetchOAuthToken(by: code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let accessToken):
                print("access token \(accessToken)")
                self.tokenStorage.token = accessToken
            case .failure(let error):
                print("[AuthViewController] \(error.localizedDescription)")
            }
            
            vc.dismiss(animated: true)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Constants
private extension AuthViewController {
    enum Constants {
        static let showWebViewSegueIdentifier = "ShowWebView"
    }
}
