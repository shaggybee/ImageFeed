//
//  ProfileImageServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

import ImageFeed
import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    static var didChangeNotification: Notification.Name = Notification.Name(rawValue: "testDidChangeNotification")
    
    var profileAvatarURL: String? = "https://test.test/avatar.jpeg"
    
    func reset() {
        profileAvatarURL = nil
    }
}
