//
//  UserResult.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.03.2026.
//

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Decodable {
    let profileImage: ProfileImage
}
