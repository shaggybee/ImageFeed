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
    
    private lazy var logger = AppLogger.shared
    
    private init() {}
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(with: token) else {
            logger.error("[ProfileService.fetchProfile] request was not generated for fetch profile")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let profile = Profile(
                    username: data.username,
                    firstName: data.firstName,
                    lastName: data.lastName,
                    bio: data.bio,
                )
                
                self.profile = profile
                
                completion(.success(profile))
            case .failure(let error):
                self.logger.error("[ProfileService.fetchProfile] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeProfileRequest(with token: String) -> URLRequest? {
        guard let url = URL(string:  AuthorizationConstants.defaultBaseURLString + NetworkingConstants.API.userProfile) else {
            logger.error("[ProfileService.makeProfileRequest] failed to create URL")
            
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setAuthorizationHeader(with: token)
        
        return request
    }
}
