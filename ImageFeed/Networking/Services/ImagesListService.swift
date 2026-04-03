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
    static let didChangeNotification = Notification.Name(Constants.imagesListServiceDidChangeNotification)
    
    // MARK: - Public properties
    var photosCount: Int { photos.count }
    
    // MARK: - Private properties
    private(set) var photos: [Photo] = []
    private var loadPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private lazy var logger = AppLogger.shared
    private lazy var tokenStorage = OAuth2TokenStorage.shared
    private lazy var notificationCenter = NotificationCenter.default
    private lazy var dateFormatterForISO8601 = ISO8601DateFormatter()
    
    private init() {}
    
    // MARK: - Public methods
    func reset() {
        photos = []
        lastLoadedPage = nil
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard changeLikeTask == nil else { return }
        
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
        
        changeLikeTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UpdatePhotoResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                if let index = photos.firstIndex(where: { $0.id == photoId }) {
                    photos[index] = transform(photoResult: data.photo)
                } else {
                    logger.info("[ImagesListService.changeLike] There are no photos with this ID in the list")
                }
                
                completion(.success(()))
            case .failure(let error):
                logger.error("[ImagesListService.changeLike] request ended with an error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            changeLikeTask = nil
        }
        
        changeLikeTask?.resume()
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard loadPhotosTask == nil else { return }
        
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
        
        loadPhotosTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                if data.isEmpty {
                    loadPhotosTask = nil
                    
                    completion(.success([]))
                    
                    return
                }
                
                let transformPhotos = data.map { self.transform(photoResult: $0) }
                
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
            
            loadPhotosTask = nil
        }
        
        loadPhotosTask?.resume()
    }
    
    // MARK: - Private methods
    private func makeFetchPhotosRequest(for page: Int, with token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: NetworkingConstants.API.photos.fullPath) else {
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
        guard let url = URL(string: NetworkingConstants.API.photoLike(id: photoId).fullPath) else {
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
    
    private func transform(photoResult: PhotoResult) -> Photo {
        Photo(
            id: photoResult.id,
            size: CGSize(
                width: photoResult.width,
                height: photoResult.height),
            createdAt: dateFormatterForISO8601.date(from: photoResult.createdAt),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}

private extension ImagesListService {
    enum Constants {
        static let imagesListServiceDidChangeNotification = "ImagesListServiceDidChange"
    }
}
