//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 28.02.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private properties
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    private lazy var profileService = ProfileService.shared
    private lazy var profileImageService = ProfileImageService.shared
    private lazy var logger = AppLogger.shared
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .launchScreenLogo))
        
        return imageView
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token, !token.isEmpty {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoImage)
        
        UIBlockingProgressHUD.configProgressHUD()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func presentAuthViewController() {
        let authViewController = UIStoryboard(name: Constants.storyboardName, bundle: .main)
            .instantiateViewController(identifier: Constants.authViewControllerIdentifier)
        
        guard let authViewController = authViewController as? AuthViewController else {
            assertionFailure("Failed to obtain AuthViewController")

            return
        }
        
        authViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else
        {
            assertionFailure("Invalid window configuration")
            
            return
        }
        
        let tabBarController = UIStoryboard(name: Constants.storyboardName, bundle: .main)
            .instantiateViewController(identifier: Constants.tabBarViewControllerIdentifier)
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImage(for: profile.username) { _ in }
                
                switchToTabBarController()
            case .failure(let error):
                self.logger.error("[SplashViewController.fetchProfile] Error: \(error)")
                break
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Constants
private extension SplashViewController {
    enum Constants {
        static let storyboardName = "Main"
        static let tabBarViewControllerIdentifier = "TabBarViewController"
        static let authViewControllerIdentifier = "AuthViewController"
    }
}
