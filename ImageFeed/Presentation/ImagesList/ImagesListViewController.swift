//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 31.01.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    private let photosNames: [String] = (0..<20).map{ String($0) }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
    }
    
    // MARK: - Private methods
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = Constants.tableContentInset
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photoName = photosNames[safe: indexPath.row] else {
            return
        }
        
        cell.config(
            with: photoName,
            isLiked: indexPath.row % 2 == 0
        )
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueIdentifierForSignalImage, sender: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
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
        guard let photoName = photosNames[safe: indexPath.row], let image = UIImage(named: photoName) else {
            return 0
        }
        
        let cellImageWidth = tableView.bounds.width - Constants.cellImageInset.left - Constants.cellImageInset.right
        let scale = cellImageWidth / image.size.width
        let cellHeight = image.size.height * scale + Constants.cellImageInset.top + Constants.cellImageInset.bottom

        return cellHeight
    }
}

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifierForSignalImage {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.image = UIImage(named: photosNames[indexPath.row])
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Constants
extension ImagesListViewController {
    private enum Constants {
        static let sectionsCount: Int = 1
        
        static let cellImageInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        static let segueIdentifierForSignalImage = "ShowSingleImage"
    }
}
