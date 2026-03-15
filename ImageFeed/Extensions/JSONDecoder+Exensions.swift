//
//  JSONDecoder+Exensions.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 14.03.2026.
//

import Foundation

extension JSONDecoder {
    static let snakeCaseDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
}
