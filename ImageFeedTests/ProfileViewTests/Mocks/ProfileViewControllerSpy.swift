//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    // MARK: - Public properties
    var presenter: ProfileViewPresenterProtocol?
    var avatarURL: URL?
    var profileDetails: Profile?
    var isSwitchedToSplashScreen: Bool = false
    
    // MARK: - Public methods
    func updateAvatar(by url: URL) {
        avatarURL = url
    }
    
    func updateProfileDetails(profile: Profile) {
        profileDetails = profile
    }
    
    func switchToSplashScreen() {
        isSwitchedToSplashScreen.toggle()
    }
    
    func didTapLogout() {
        presenter?.logout()
    }
}
