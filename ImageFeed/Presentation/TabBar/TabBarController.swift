//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 18.03.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
    }
    
    //MARK: - Private methods
    private func configTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlack

        tabBar.standardAppearance = appearance
        tabBar.tintColor = .ypWhite
        
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenter()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil)
        
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListViewPresenter
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

