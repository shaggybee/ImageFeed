//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
    init(profileService: ProfileServiceProtocol,
         profileLogoutService: ProfileLogoutServiceProtocol,
         notificationCenter: NotificationCenter,
         profileImageService: ProfileImageServiceProtocol
    )
}
