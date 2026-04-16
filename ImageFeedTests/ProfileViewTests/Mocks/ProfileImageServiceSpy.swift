//
//  ProfileImageServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed
import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    // MARK: - Public properties
    var profileAvatarURL: String? = "https://test.test/avatar.jpeg"
    
    // MARK: - Public methods
    func reset() {
        profileAvatarURL = nil
    }
}
