//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.04.2026.
//

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func reset()
}
