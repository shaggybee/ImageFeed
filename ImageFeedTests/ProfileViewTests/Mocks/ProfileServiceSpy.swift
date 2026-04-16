//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed

final class ProfileServiceSpy: ProfileServiceProtocol {
    // MARK: - Public properties
    var profile: Profile? = Profile(
        username: "JimBim",
        firstName: "Jim",
        lastName: "Bim",
        bio: "born lived lives")
    
    // MARK: - Public methods
    func reset() {
        profile = nil
    }
}
