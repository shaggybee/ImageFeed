//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 30.03.2026.
//

import Foundation
import CoreGraphics

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: Constants.imagesListServiceDidChangeNotification)
    
    // MARK: - Public properties
    var photosCount: Int { photos.count }
    
    // MARK: - Private properties
    private(set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private lazy var logger = AppLogger.shared
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    private lazy var notificationCenter = NotificationCenter.default
    private lazy var dateFormatterForISO8601 = ISO8601DateFormatter()
    
    private init() {}
    
    // MARK: - Public methods
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard let token = tokenStorage.token, !token.isEmpty else {
            logger.error("[ImagesListService.changeLike] authorization token missing or contains an empty string")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike, with: token) else {
            logger.error("[ImagesListService.changeLike] request was not generated for change photo like")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UpdatePhotoResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success:
                if let index = photos.firstIndex(where: { $0.id == photoId }), let photo = photos[safe: index] {
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                    
                    photos[index] = newPhoto
                } else {
                    logger.info("[ImagesListService.changeLike] There are no photos with this ID in the list")
                }
                
                completion(.success(()))
            case .failure(let error):
                logger.error("[ImagesListService.changeLike] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        if task != nil { return }
        
        guard let token = tokenStorage.token, !token.isEmpty else {
            logger.error("[ImagesListService.fetchPhotosNextPage] authorization token missing or contains an empty string")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        let loadingPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeFetchPhotosRequest(for: loadingPage, with: token) else {
            logger.error("[ImagesListService.fetchPhotosNextPage] request was not generated for fetch photos")
            completion(.failure(NetworkError.invalidRequest))
            
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                if data.isEmpty {
                    task = nil
                    
                    completion(.success([]))
                    
                    return
                }
                
                let transformPhotos = transform(photoResult: data)
                
                photos.append(contentsOf: transformPhotos)
                lastLoadedPage = loadingPage
                
                notificationCenter.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos])
                
                completion(.success(transformPhotos))
            case .failure(let error):
                logger.error("[ImagesListService.fetchPhotosNextPage] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            task = nil
        }
        
        task?.resume()
    }
    
    // MARK: - Private methods
    private func makeFetchPhotosRequest(for page: Int, with token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(
            string: AuthorizationConstants.defaultBaseURLString +  NetworkingConstants.API.photos
        ) else {
            logger.error("[ImagesListService.makeFetchPhotosrequest] failed to create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: NetworkingConstants.QueryItem.page,
                value: String(page)),
            URLQueryItem(
                name: NetworkingConstants.QueryItem.perPage,
                value: String(NetworkingConstants.Pagination.defaultPerPage))
        ]
        
        guard let url = urlComponents.url else {
            logger.error("[ImagesListService.makeFetchPhotosrequest] failed to get URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setAuthorizationHeader(with: token)
        
        return request
    }
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool, with token: String) -> URLRequest? {
        let api = NetworkingConstants.API.photoLikeChange.replacingOccurrences(of: NetworkingConstants.idStub, with: photoId)
        
        guard let url = URL(string: AuthorizationConstants.defaultBaseURLString + api) else {
            logger.error("[ImagesListService.makeChangeLikeRequest] failed to create URL")
            
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike
            ? HTTPMethod.post.rawValue
            : HTTPMethod.delete.rawValue
        request.setAuthorizationHeader(with: token)
        
        return request
    }
    
    private func transform(photoResult: [PhotoResult]) -> [Photo] {
        photoResult.map { photo in
            Photo(
                id: photo.id,
                size: CGSize(
                    width: photo.width,
                    height: photo.height),
                createdAt: dateFormatterForISO8601.date(from: photo.createdAt),
                welcomeDescription: photo.description,
                thumbImageURL: photo.urls.small,
                largeImageURL: photo.urls.full,
                isLiked: photo.likedByUser
            )
        }
    }
}

private extension ImagesListService {
    enum Constants {
        static let imagesListServiceDidChangeNotification = "ImagesListServiceDidChange"
    }
}
