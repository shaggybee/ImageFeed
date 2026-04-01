//
//  PhotoURLsResult.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 31.03.2026.
//

import Foundation

struct PhotoURLsResult: Decodable {
    let thumb: String
    let full: String
    let regular: String
}
