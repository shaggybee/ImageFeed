//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 02.04.2026.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    // MARK: - Private properties
    private lazy var imagesListService = ImagesListService.shared
    private lazy var profileImageService = ProfileImageService.shared
    private lazy var profileService = ProfileService.shared
    private lazy var cookieStorage = HTTPCookieStorage.shared
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    
    private init() { }
    
    // MARK: - Private methods
    private func cleanCookies() {
        cookieStorage.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {}
                )
            }
        }
    }
}

// MARK: - ProfileLogoutServiceProtocol
extension ProfileLogoutService: ProfileLogoutServiceProtocol {
    func logout() {
        cleanCookies()
        imagesListService.reset()
        profileImageService.reset()
        profileService.reset()
        tokenStorage.reset()
    }
}
