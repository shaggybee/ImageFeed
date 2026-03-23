//
//  Constants.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 22.02.2026.
//

enum AuthorizationConstants {
    static let accessKey = "xyuMg0ZhoO4QXOnCydq49veeBaQt20Qp9wX62i9QasQ"
    static let secretKey = "oWkXxNTv5kdSHzBkKSiACzBc_if9hNyeds3rF-j-COU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let tokenURL = "https://unsplash.com/oauth/token"
    static let authorizeRelativeCodeAddress = "/oauth/authorize/native"
    
    enum API {
        static let userProfile = "/me"
        static let users = "/users"
    }
    
    enum QueryItem {
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
        static let redirectUri = "redirect_uri"
        static let code = "code"
        static let grantType = "grant_type"
        static let scope = "scope"
        static let responseType = "response_type"
    }
    
    enum QueryItemValue {
        static let code = "code"
        static let authorizationCode = "authorization_code"
    }
}
