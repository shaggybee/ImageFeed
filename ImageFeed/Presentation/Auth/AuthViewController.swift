//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 23.02.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Public properties
    public weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private properties
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    private lazy var logger = AppLogger.shared
    
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
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: Constants.Alert.title,
            message: Constants.Alert.subtitle,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Alert.buttonText, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        vc.navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(by: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }

            switch result {
            case .success(let accessToken):
                self.tokenStorage.token = accessToken
                delegate?.didAuthenticate(self)
            case .failure(let error):
                self.showErrorAlert()
                self.logger.error("[AuthViewController.webViewViewController] Error: \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Constants
private extension AuthViewController {
    enum Constants {
        static let showWebViewSegueIdentifier = "ShowWebView"
        
        enum Alert {
            static let title = "Что-то пошло не так"
            static let subtitle = "Не удалось войти в систему"
            static let buttonText = "Ok"
        }
    }
}
