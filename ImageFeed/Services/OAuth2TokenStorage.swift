//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 27.02.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    // MARK: - Private Properties
    private lazy var storage = KeychainWrapper.standard
}

// MARK: - OAuth2TokenStorageProtocol
extension OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    func reset() {
        token = nil
    }
    
    var token: String? {
        get {
            storage.string(forKey: Constants.storageAccessTokenKey)
        }
        set {
            if let newToken = newValue {
                storage.set(newToken, forKey: Constants.storageAccessTokenKey)
            } else {
                storage.removeObject(forKey: Constants.storageAccessTokenKey)
            }
        }
    }
}

// MARK: - Constants
private extension OAuth2TokenStorage {
    enum Constants {
        static let storageAccessTokenKey = "accessToken"
    }
}
