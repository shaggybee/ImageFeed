//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 15.04.2026.
//

import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var photosCount: Int { photos.count }
    
    // MARK: - Private properties
    private var imagesListService: ImagesListServiceProtocol
    private var notificationCenter: NotificationCenter
    private lazy var logger = AppLogger.shared
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(
        imagesListService: ImagesListServiceProtocol = ImagesListService.shared,
        notificationCenter: NotificationCenter = .default
    ) {
        self.imagesListService = imagesListService
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        addImagesListServiceObserver()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let newPhotos):
                var text = "[ImagesListViewPresenter.fetchPhotos] "
                text += newPhotos.isEmpty
                    ? "All available photos have been uploaded, no new photos available"
                    : "\(newPhotos.count) photos uploaded"
                
                logger.info(text)
            case .failure(let error):
                logger.error("[ImagesListViewPresenter.fetchPhotos] Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getLargeImageURL(for index: Int) -> URL? {
        guard let photo = photos[safe: index],
              let url = URL(string: photo.largeImageURL) else { return nil }
        
        return url
    }
    
    func changeLike(for index: Int, _ completion: @escaping () -> Void) {
        guard let photo = photos[safe: index] else {
            completion()
            
            return
        }
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                completion()
                
                guard let self else { return }
                
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    
                    if self.photos[index].id == photo.id {
                        self.view?.changeLikedStateForCell(
                            by: index,
                            isLike: self.photos[index].isLiked)
                    }
                case .failure(let error):
                    self.view?.showErrorAlert(for: !photo.isLiked)
                    
                    self.logger.error("[ImagesListViewPresenter.changeLike] Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchPhotosIfNeeded(for index: Int) {
        if index + 1 == photosCount {
            fetchPhotos()
        }
    }
    
    // MARK: - Private methods
    private func addImagesListServiceObserver() {
        imagesListServiceObserver = notificationCenter.addObserver(
            forName: type(of: imagesListService).didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updatePhotos()
            })
    }
    
    private func updatePhotos() {
         let currentCount = photos.count
         let newCount = imagesListService.photosCount
         
         photos = imagesListService.photos
         
         view?.updateTableViewAnimated(from: currentCount, to: newCount)
     }
}
