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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIBlockingProgressHUD.configProgressHUD()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token, !token.isEmpty {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: Constants.showAuthViewSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != Constants.showAuthViewSegueIdentifier {
            super.prepare(for: segue, sender: sender)
            
            return
        }
        
        if let navigationController = segue.destination as? UINavigationController,
           let authViewController = navigationController.viewControllers.first as? AuthViewController
        {
            authViewController.delegate = self
        } else {
            assertionFailure("Failed to prepare for \(Constants.showAuthViewSegueIdentifier)")
        }
    }
    
    // MARK: - Private methods
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
                print("[SplashViewController.fetchProfile] Error: \(error)")
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
        static let showAuthViewSegueIdentifier = "showAuthView"
        static let storyboardName = "Main"
        static let tabBarViewControllerIdentifier = "TabBarViewController"
    }
}
