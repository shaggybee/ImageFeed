//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

import ImageFeed

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: Profile? = Profile(
        username: "JimBim",
        firstName: "Jim",
        lastName: "Bim",
        bio: "born lived lives")
    
    func reset() {
        profile = nil
    }
}
