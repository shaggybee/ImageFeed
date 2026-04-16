//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 31.01.2026.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // MARK: - Public properties
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: - Private properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.contentInset = Constants.tableContentInset
        tableView.separatorColor = .ypBlack
        
        return tableView
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        presenter?.viewDidLoad()
        setElements()
    }
    
    // MARK: - Public methods
    func updateTableViewAnimated(from indexStart: Int, to indexEnd: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (indexStart..<indexEnd).map { IndexPath(row: $0, section: 0) }
            
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showErrorAlert(for isLike: Bool) {
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
    
    func changeLikedStateForCell(by index: Int, isLike: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        
        cell.setIsLiked(isLike)
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
        guard let photo = presenter?.photos[safe: indexPath.row] else { return }
        
        cell.delegate = self
        cell.config(with: photo)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = presenter?.getLargeImageURL(for: indexPath.row) else { return }
        
        let singleImageViewController = SingleImageViewController(imageUrl: url)
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosIfNeeded(for: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
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
        guard let photo = presenter?.photos[safe: indexPath.row] else {
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
        guard let presenter, let rowIndex = tableView.indexPath(for: cell)?.row else { return }
        
        UIBlockingProgressHUD.show()
        
        presenter.changeLike(for: rowIndex) {
            UIBlockingProgressHUD.dismiss()
        }
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
