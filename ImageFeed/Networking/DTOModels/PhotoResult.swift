//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 31.03.2026.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: PhotoURLsResult
}
