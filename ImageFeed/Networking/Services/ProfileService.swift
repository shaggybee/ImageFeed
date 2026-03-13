//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.03.2026.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    // MARK: - Private properties
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private lazy var decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    private init() {}
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileReauest(with: token) else {
            print("[ProfileService] request was not generated for fetch profile")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let responseBody = try self.decoder.decode(ProfileResult.self, from: data)
                    
                    let profile = Profile(
                        username: responseBody.username,
                        firstName: responseBody.firstName,
                        lastName: responseBody.lastName,
                        bio: responseBody.bio,
                    )
                    
                    self.profile = profile
                    
                    completion(.success(profile))
                } catch {
                    
                }
            case .failure(let error):
                print("[ProfileService] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeProfileReauest(with token: String) -> URLRequest? {
        guard let url = URL(string:  AuthorizationConstants.defaultBaseURLString + AuthorizationConstants.API.userProfile) else {
            print("[ProfileService] failed to create URL")
            
            return nil
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setAuthorizationHeader(with: token)
        
        return request
    }
}
