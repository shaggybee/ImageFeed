//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

public protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func reset()
}
