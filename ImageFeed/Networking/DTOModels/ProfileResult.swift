//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.03.2026.
//

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
