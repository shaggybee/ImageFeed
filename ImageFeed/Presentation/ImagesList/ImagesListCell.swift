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
    @IBOutlet private weak var labelContainerView: UIView!
    
    // MARK: - Private properties
    private var labelContainerGradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if labelContainerGradientLayer == nil {
            setGradientLayerForLabelContainer()
        }
    }
    
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
    
    // MARK: - Private methods
    private func setGradientLayerForLabelContainer() {
        labelContainerGradientLayer = CAGradientLayer()
        
        guard let labelContainerGradientLayer else {
            return
        }
        
        labelContainerGradientLayer.cornerRadius = 16
        labelContainerGradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        labelContainerGradientLayer.colors = [
            UIColor.ypBackground.withAlphaComponent(0).cgColor,
            UIColor.ypBackground.withAlphaComponent(0.5).cgColor
        ]
        
        labelContainerGradientLayer.startPoint = CGPoint.zero
        labelContainerGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        labelContainerGradientLayer.frame = labelContainerView.bounds
        
        labelContainerView.layer.insertSublayer(labelContainerGradientLayer, at: 0)
    }
}
