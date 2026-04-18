//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    // MARK: - Public properties
    var isUserSessionDataReset: Bool = false
    
    // MARK: - Public methods
    func logout() {
        isUserSessionDataReset = true
    }
}
