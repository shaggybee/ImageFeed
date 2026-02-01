//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 01.02.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Static Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    // MARK: - Public methods
    func config(with imageName: String, isLiked: Bool) {
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        let imageButton = isLiked
            ? UIImage(named: "FavoritesActive")
            : UIImage(named: "FavoritesNoActive")
        
        cellImage.image = image
        likeButton.setImage(imageButton, for: .normal)
        dateLabel.text = Date().longDateString
    }
}
