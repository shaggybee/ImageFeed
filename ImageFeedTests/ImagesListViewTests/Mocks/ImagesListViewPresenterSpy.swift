//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 16.04.2026.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    var photos: [Photo] = []
    
    var photosCount: Int = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotos() { }
    
    func fetchPhotosIfNeeded(for index: Int) { }
    
    func getLargeImageURL(for index: Int) -> URL? {
        URL(string: photos[safe: index]?.largeImageURL ?? "")
    }
    
    func changeLike(for index: Int, _ completion: @escaping () -> Void) { }
}
