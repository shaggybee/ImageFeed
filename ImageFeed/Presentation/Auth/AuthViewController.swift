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
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .logoOfUnsplash))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }().forAutoLayout
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle(Constants.loginButtonText, for: .normal)
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.Typography.buttonTitleSize, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        button.addTarget(
            self,
            action: #selector(didTapLogin),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setElements()
    }
    
    // MARK: - Private methods
    @objc private func didTapLogin() {
        showWebViewController()
    }

    private func setElements() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(logoImage)
        view.addSubview(loginButton)
        
        configureBackButton()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: Constants.logoImageSize),
            logoImage.widthAnchor.constraint(equalToConstant: Constants.logoImageSize),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: Constants.loginButtonHeight),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.paddingS),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.paddingS),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomPadding)
        ])
    }
    
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
    
    private func showWebViewController() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        navigationController?.popViewController(animated: true)
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
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Constants
private extension AuthViewController {
    enum Constants {
        static let loginButtonText = "Войти"
        static let loginButtonHeight: CGFloat = 48
        static let logoImageSize: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 16
        static let buttonBottomPadding: CGFloat = 90
        
        static let paddingS: CGFloat = 16
    
        enum Alert {
            static let title = "Что-то пошло не так"
            static let subtitle = "Не удалось войти в систему"
            static let buttonText = "Ok"
        }
        
        enum Typography {
            static let buttonTitleSize: CGFloat = 17
        }
    }
}
