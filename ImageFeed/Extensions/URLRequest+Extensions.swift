//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.03.2026.
//

import Foundation

extension URLRequest {
    mutating func setAuthorizationHeader(with token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
