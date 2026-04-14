//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var avatarURL: URL?
    var profileDetails: Profile?
    var isSwitchedToSplashScreen: Bool = false
    
    func updateAvatar(by url: URL) {
        avatarURL = url
    }
    
    func updateProfileDetails(profile: Profile) {
        profileDetails = profile
    }
    
    func switchToSplashScreen() {
        isSwitchedToSplashScreen.toggle()
    }
}
