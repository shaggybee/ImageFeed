//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: AuthorizationConstants.accessKey,
            secretKey: AuthorizationConstants.secretKey,
            redirectURI: AuthorizationConstants.redirectURI,
            accessScope: AuthorizationConstants.accessScope,
            defaultBaseURLString: NetworkingConstants.baseApiURLString,
            authURLString: AuthorizationConstants.tokenURL)
    }
}
