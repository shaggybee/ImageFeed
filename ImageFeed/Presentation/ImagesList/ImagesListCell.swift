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
    
    // MARK: - Private properties
    private var labelContainerGradientLayer: CAGradientLayer?
    private let today = Date()
    
    private lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.cornerRadius = Constants.cornerRadius
        cellImage.layer.masksToBounds = true
        
        return cellImage
    }().forAutoLayout
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .clear
        button.setImage(.favoritesActive, for: .normal)
        
        return button
    }().forAutoLayout
    
    private lazy var labelContainerView: UIView = {
        let view = UIView()
        
        return view
    }().forAutoLayout
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: Constants.Typography.dateLabelSize)
        
        return label
    }().forAutoLayout

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
            ? UIImage(resource: .favoritesActive)
            : UIImage(resource: .favoritesNoActive)
        
        cellImage.image = image
        likeButton.setImage(imageButton, for: .normal)
        dateLabel.text = today.longDateString
    }
    
    // MARK: - Private methods
    private func setElements() {
        backgroundColor = .ypBlack
        selectionStyle = .none
        
        labelContainerView.addSubview(dateLabel)
        addSubview(cellImage)
        addSubview(likeButton)
        addSubview(labelContainerView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            
            dateLabel.heightAnchor.constraint(equalToConstant: Constants.dateLabelHeight),
            dateLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -Constants.paddingXS),
            dateLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: Constants.paddingXS),
            dateLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: Constants.paddingXSS),

            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.paddingS),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.paddingS),
            cellImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.paddingXSS),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.paddingXSS),
            
            labelContainerView.heightAnchor.constraint(equalToConstant: Constants.labelContainerView),
            labelContainerView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
        ])
    }
    
    private func setGradientLayerForLabelContainer() {
        labelContainerGradientLayer = CAGradientLayer()
        
        guard let labelContainerGradientLayer else {
            return
        }
        
        labelContainerGradientLayer.cornerRadius = Constants.cornerRadius
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

// MARK: - Constants
private extension ImagesListCell {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        
        static let likeButtonSize: CGFloat = 44
        static let dateLabelHeight: CGFloat = 18
        static let labelContainerView: CGFloat = 30
        
        static let paddingXSS: CGFloat = 4
        static let paddingXS: CGFloat = 8
        static let paddingS: CGFloat = 16
        
        enum Typography {
            static let dateLabelSize: CGFloat = 13
        }
    }
}
