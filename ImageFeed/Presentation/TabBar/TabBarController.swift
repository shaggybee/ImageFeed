//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 18.03.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: Constants.imagesListViewControllerIdentifier
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

// MARK: - Constants
private extension TabBarController {
    enum Constants {
        static let storyboardName = "Main"
        static let imagesListViewControllerIdentifier = "ImagesListViewController"
    }
}
