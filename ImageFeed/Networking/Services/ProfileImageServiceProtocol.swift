//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

import Foundation

public protocol ProfileImageServiceProtocol {
    static var didChangeNotification: Notification.Name { get }
    var profileAvatarURL: String? { get }
    func reset()
}
