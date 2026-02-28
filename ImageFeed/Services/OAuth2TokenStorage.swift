//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 27.02.2026.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
}

// MARK: - OAuth2TokenStorageProtocol
extension OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    var token: String? {
        get {
            storage.string(forKey: Constants.storageAccessTokenKey)
        }
        set {
            storage.set(newValue, forKey: Constants.storageAccessTokenKey)
        }
    }
}

// MARK: - Constants
private extension OAuth2TokenStorage {
    enum Constants {
        static let storageAccessTokenKey = "accessToken"
    }
}
