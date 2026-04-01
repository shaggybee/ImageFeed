//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 31.01.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.contentInset = Constants.tableContentInset
        tableView.separatorColor = .ypBlack
        
        return tableView
    }().forAutoLayout
    
    private lazy var imagesListService = ImagesListService.shared
    private lazy var notificationCenter = NotificationCenter.default
    private lazy var logger = AppLogger.shared
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        addImagesListServiceObserver()
        setElements()
        fetchPhotos()
    }
    
    // MARK: - Private methods
    private func setElements() {
        tableView.backgroundColor = .ypBlack
        
        view.addSubview(tableView)
        
        setConstraints()
        configTable()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.row] else { return }
        
        cell.delegate = self
        cell.config(with: photo)
    }
    
    private func fetchPhotos() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let newPhotos):
                var text = "[ImagesListViewController.fetchPhotos] "
                text += newPhotos.isEmpty
                    ? "All available photos have been uploaded, no new photos available"
                    : "\(newPhotos.count) photos uploaded"
                
                logger.info(text)
            case .failure(let error):
                logger.error("[ImagesListViewController.fetchPhotos] Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateTableViewAnimated() {
        let currentCount = photos.count
        let newCount = imagesListService.photosCount
        
        photos = imagesListService.photos
        
        tableView.performBatchUpdates {
            let indexPaths = (currentCount..<newCount).map { IndexPath(row: $0, section: 0) }
            
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    private func addImagesListServiceObserver() {
        imagesListServiceObserver = notificationCenter.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updateTableViewAnimated()
            })
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        
        singleImageViewController.modalPresentationStyle = .fullScreen
//        singleImageViewController.image = UIImage(named: photosNames[indexPath.row])
        
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == imagesListService.photosCount {
            fetchPhotos()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = photos[safe: indexPath.row] else {
            return 0
        }
        
        let cellImageWidth = tableView.bounds.width - Constants.cellImageInset.left - Constants.cellImageInset.right
        let scale = cellImageWidth / photo.size.width
        let cellHeight = photo.size.height * scale + Constants.cellImageInset.top + Constants.cellImageInset.bottom

        return cellHeight
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLike(for cell: ImagesListCell) {
        guard let rowIndex = tableView.indexPath(for: cell)?.row,
              let photo = photos[safe: rowIndex] else { return }
        
        UIBlockingProgressHUD.show()
    
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                guard let self else { return }
                
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    
                    if self.photos[rowIndex].id == photo.id {
                        cell.setIsLiked(self.photos[rowIndex].isLiked)
                    }
                case .failure(let error):
                    self.showErrorAlert(for: !photo.isLiked)
                    
                    self.logger.error("[ImagesListViewController.changeLike] Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showErrorAlert(for isLike: Bool) {
        let alert = UIAlertController(
            title: Constants.Alert.title,
            message: isLike
                ? Constants.Alert.failedToLike
                : Constants.Alert.failedToRemoveLike,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Alert.buttonText, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Constants
extension ImagesListViewController {
    private enum Constants {
        static let sectionsCount: Int = 1
        
        static let cellImageInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        enum Alert {
            static let title = "Что-то пошло не так"
            static let failedToLike = "Не удалось поставить лайк"
            static let failedToRemoveLike = "Не удалось снять лайк"
            static let buttonText = "Ok"
        }
    }
}
