//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 27.02.2026.
//

import Foundation

final class OAuth2Service {
    static let shared: OAuth2Service = OAuth2Service()
    
    // MARK: - Private properties
    private var lastCode: String?
    private var task: URLSessionTask?
    private lazy var logger = AppLogger.shared
    
    private init() {}
    
    // MARK: - Public methods
    func fetchOAuthToken(
        by code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if (code == lastCode) {
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        task?.cancel()
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(with: code) else {
            logger.error("[OAuth2Service.fetchOAuthToken] request was not generated for fetch auth token")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success(let data):
                        let accessToken = data.accessToken
                        
                        completion(.success(accessToken))
                    case .failure(let error):
                        self.logger.error("[OAuth2Service.fetchOAuthToken] request ended with an error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                    self.lastCode = nil
                    self.task = nil
                }
            }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeOAuthTokenRequest(with code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: AuthorizationConstants.tokenURL) else {
            logger.error("[OAuth2Service.makeOAuthTokenRequest] failed to create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: AuthorizationConstants.QueryItem.clientId, value: AuthorizationConstants.accessKey),
            URLQueryItem(name: AuthorizationConstants.QueryItem.clientSecret, value: AuthorizationConstants.secretKey),
            URLQueryItem(name: AuthorizationConstants.QueryItem.redirectUri, value: AuthorizationConstants.redirectURI),
            URLQueryItem(name: AuthorizationConstants.QueryItem.code, value: code),
            URLQueryItem(name: AuthorizationConstants.QueryItem.grantType, value: AuthorizationConstants.QueryItemValue.authorizationCode),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            logger.error("[OAuth2Service.makeOAuthTokenRequest] failed to get URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }
}
