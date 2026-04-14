//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private properties
    private var profileService: ProfileServiceProtocol
    private var profileLogoutService: ProfileLogoutServiceProtocol
    private var notificationCenter: NotificationCenter
    private var profileImageService: ProfileImageServiceProtocol
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
         notificationCenter: NotificationCenter = .default,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.notificationCenter = notificationCenter
        self.profileImageService = profileImageService
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        addImageServiceObserver()
        
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        
        updateAvatar()
    }
    
    func logout() {
        profileLogoutService.logout()
        view?.switchToSplashScreen()
    }
    
    func updateAvatar() {
        guard let profileAvatarURL = profileImageService.profileAvatarURL,
              let url = URL(string: profileAvatarURL) else { return }
        
        view?.updateAvatar(by: url)
    }
    
    // MARK: - Private methods
    private func addImageServiceObserver() {
        profileImageServiceObserver = notificationCenter.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updateAvatar()
            })
    }
}
