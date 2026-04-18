//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(by url: URL)
    func updateProfileDetails(profile: Profile)
    func switchToSplashScreen()
    func didTapLogout()
}
