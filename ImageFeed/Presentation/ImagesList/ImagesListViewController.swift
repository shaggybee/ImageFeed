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
    
    private let photosNames: [String] = (0..<20).map{ String($0) }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setElements()
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
        let singleImageViewController = SingleImageViewController()
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.image = UIImage(named: photosNames[indexPath.row])
        
        present(singleImageViewController, animated: true)
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

// MARK: - Constants
extension ImagesListViewController {
    private enum Constants {
        static let sectionsCount: Int = 1
        
        static let cellImageInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
