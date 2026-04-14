//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

import ImageFeed

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var isUserSessionDataReset: Bool = false
    
    func logout() {
        isUserSessionDataReset = true
    }
}
