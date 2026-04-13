//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    
    // MARK: - Public properties
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    // MARK: - Public methods
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == AuthorizationConstants.authorizeRelativeCodeAddress,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == AuthorizationConstants.QueryItemValue.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: AuthorizationConstants.authorizeURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: AuthorizationConstants.QueryItem.clientId, value: AuthorizationConstants.accessKey),
            URLQueryItem(name: AuthorizationConstants.QueryItem.redirectUri, value: AuthorizationConstants.redirectURI),
            URLQueryItem(name: AuthorizationConstants.QueryItem.responseType, value: AuthorizationConstants.QueryItemValue.code),
            URLQueryItem(name: AuthorizationConstants.QueryItem.scope, value: AuthorizationConstants.accessScope)
        ]
        
        return urlComponents.url
    }
}
