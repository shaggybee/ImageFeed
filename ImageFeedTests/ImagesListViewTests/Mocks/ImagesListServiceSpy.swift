//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 16.04.2026.
//

@testable import ImageFeed
import Foundation

enum ImagesListServiceErrors: Error {
    case changeLikeError
}

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    static var didChangeNotification: Notification.Name = Notification.Name(rawValue: "testDidChangeNotification")
    
    // MARK: - Public properties
    let pageSize: Int = 10
    let indexPhotoWithError = 5
    
    var photos: [Photo] = []
    var photosCount: Int {
        photos.count
    }
    var changeLikeError: ImagesListServiceErrors?
    var likedPhotoId: String?
    
    // MARK: - Public methods
    func reset() {
        photos = []
        likedPhotoId = nil
        changeLikeError = nil
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let newPhotos = generatePhotos()
        
        photos.append(contentsOf: newPhotos)
        
        NotificationCenter.default.post(
            name: ImagesListServiceSpy.didChangeNotification,
            object: nil)

        completion(.success(newPhotos))
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let index = photos.firstIndex(where: { $0.id == photoId}), index != indexPhotoWithError else {
            changeLikeError = ImagesListServiceErrors.changeLikeError
            
            return
        }

        likedPhotoId = photos[index].id
    }
    
    // MARK: - Private methods
    private func generatePhotos() -> [Photo] {
        (1...pageSize).map { index in
            Photo(
                id: String(photosCount + index),
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                welcomeDescription: nil,
                thumbImageURL: "https://test.test/thumb.jpeg",
                largeImageURL: "https://test.test/large.jpeg",
                isLiked: Bool.random()
            )
        }
    }
}
