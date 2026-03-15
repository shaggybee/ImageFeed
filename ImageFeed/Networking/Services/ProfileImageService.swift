//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 13.03.2026.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: Constants.didChangeNotificationName)
    
    // MARK: - Private properties
    private var task: URLSessionTask?
    private(set) var profileAvatarURL: String?
    
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    private lazy var notificationCenter = NotificationCenter.default
    private lazy var decoder = JSONDecoder.snakeCaseDecoder
    
    private init() {}
    
    // MARK: - Public methods
    func fetchProfileImage(for username: String, completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = tokenStorage.token, !token.isEmpty else {
            print("[ProfileImageService] authorization token missing or contains an empty string")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        guard let request = makeProfileImageRequest(for: username, with: token) else {
            print("[ProfileImageService] request was not generated for fetch profile")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] request in
            guard let self else { return }
            
            switch request {
            case .success(let data):
                do {
                    let responseBody = try self.decoder.decode(UserResult.self, from: data)
                    
                    self.profileAvatarURL = responseBody.profileImage.small
                    
                    completion(.success(self.profileAvatarURL ?? ""))
                    
                    notificationCenter.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.profileAvatarURL ?? ""])
                } catch {
                    print("[ProfileImageService] response decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[ProfileImageService] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeProfileImageRequest(for username: String, with token: String) -> URLRequest? {
        guard let url = URL(string: AuthorizationConstants.defaultBaseURLString + AuthorizationConstants.API.users + "/\(username)") else {
            print("[ProfileImageService] failed to create URL")
            
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setAuthorizationHeader(with: token)
        
        return request
    }
}

private extension ProfileImageService {
    enum Constants {
        static let didChangeNotificationName = "ProfileImageProviderDidChange"
    }
}
