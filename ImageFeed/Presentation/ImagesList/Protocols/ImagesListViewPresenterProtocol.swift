//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 15.04.2026.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func fetchPhotos()
    func fetchPhotosIfNeeded(for index: Int)
    func getLargeImageURL(for index: Int) -> URL?
    func changeLike(for index: Int, _ completion: @escaping () -> Void)
}
