//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 15.04.2026.
//

import Foundation

protocol ImagesListServiceProtocol {
    static var didChangeNotification: Notification.Name { get }
    var photos: [Photo] { get }
    var photosCount: Int { get }
    func reset()
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void)
}
