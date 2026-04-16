//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var profileAvatarURL: String? { get }
    func reset()
}
