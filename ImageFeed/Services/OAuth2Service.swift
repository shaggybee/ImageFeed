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
    private lazy var decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    private init() {}
    
    // MARK: - Public methods
    func fetchOAuthToken(
        by code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = makeOAuthTokenRequest(with: code) else {
            print("[OAuth2Service] request was not generated for fetch auth token")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task =  URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let responseBody = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = responseBody.accessToken
                    
                    completion(.success(accessToken))
                } catch {
                    print("[OAuth2Service] response decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[OAuth2Service] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeOAuthTokenRequest(with code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: AuthorizationConstants.tokenURL) else {
            print("[OAuth2Service] failed to create URLComponents")
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
            print("[OAuth2Service] failed to get URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }
}
