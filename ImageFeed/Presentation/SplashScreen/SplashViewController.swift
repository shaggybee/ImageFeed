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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (tokenStorage.token ?? "").isEmpty == true {
            performSegue(withIdentifier: Constants.showAuthViewSegueIdentifier, sender: nil)
        } else {
            switchToTabBarController()
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
    
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Invalid window configuration")
        
            return
        }
        
        
        let tabBarController = UIStoryboard(name: Constants.storyboardName, bundle: .main)
            .instantiateViewController(identifier: Constants.tabBarViewControllerIdentifier)
        
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        switchToTabBarController()
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
