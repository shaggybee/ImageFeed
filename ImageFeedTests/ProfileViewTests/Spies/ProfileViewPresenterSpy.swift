//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    // MARK: - Private properties
    private var profileService: ProfileServiceProtocol
    private var profileLogoutService: ProfileLogoutServiceProtocol
    private var notificationCenter: NotificationCenter
    private var profileImageService: ProfileImageServiceProtocol
    
    init(
        profileService: ProfileServiceProtocol,
        profileLogoutService: ProfileLogoutServiceProtocol,
        notificationCenter: NotificationCenter,
        profileImageService: ProfileImageServiceProtocol
    ) {
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.notificationCenter = notificationCenter
        self.profileImageService = profileImageService
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        viewDidLoadCalled = true
        
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        
        updateAvatar()
    }
    
    func updateAvatar() {
        guard let profileAvatarURL = profileImageService.profileAvatarURL,
              let url = URL(string: profileAvatarURL) else { return }
        
        view?.updateAvatar(by: url)
    }
    
    func logout() {
        profileLogoutService.logout()
        view?.switchToSplashScreen()
    }
}
