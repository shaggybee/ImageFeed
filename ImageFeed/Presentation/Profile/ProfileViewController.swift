//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 08.02.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var profileService = ProfileService.shared
    private lazy var profileImageService = ProfileImageService.shared
    private lazy var notificationCenter = NotificationCenter.default
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .avatar))
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.avatarImageSize / 2
        
        return imageView
    }().forAutoLayout
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(resource: .exit), for: .normal)
        
        return button
    }().forAutoLayout
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: Constants.Typography.title)
        label.textColor = .ypWhite
        
        return label
    }().forAutoLayout
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.Typography.body)
        label.textColor = .ypGray
        
        return label
    }().forAutoLayout
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: Constants.Typography.body)
        label.textColor = .ypWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }().forAutoLayout
    
    private lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = Constants.paddingXS

        return stackView
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        addImageServiceObserver()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        updateAvatar()
    }
    
    // MARK: - Private methods
    private func setElements() {
        avatarImage.image = UIImage(resource: .tabProfileActive)
        
        view.backgroundColor = .ypBlack
        
        view.addSubview(avatarImage)
        view.addSubview(logoutButton)
        view.addSubview(profileInfoStackView)
        
        profileInfoStackView.addArrangedSubview(nameLabel)
        profileInfoStackView.addArrangedSubview(loginLabel)
        profileInfoStackView.addArrangedSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            avatarImage.heightAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.paddingS),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingM),
            
            profileInfoStackView.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            profileInfoStackView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: Constants.paddingXS),
            profileInfoStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.paddingS),
            
            logoutButton.widthAnchor.constraint(equalToConstant: Constants.logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalToConstant: Constants.logoutButtonSize),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.paddingS),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor)
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func addImageServiceObserver() {
        profileImageServiceObserver = notificationCenter.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updateAvatar()
            })
    }
    
    private func updateAvatar() {
        guard let profileAvatarURL = profileImageService.profileAvatarURL,
              let url = URL(string: profileAvatarURL) else { return }
        
        let placeholderImage = UIImage(resource: .tabProfileActive)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.avatarImageSize))
        
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(with: url, placeholder: placeholderImage)
    }
}

// MARK: - Constants
private extension ProfileViewController {
    enum Constants {
        static let logoutButtonSize: CGFloat = 44
        static let avatarImageSize: CGFloat = 70
        static let paddingXS: CGFloat = 8
        static let paddingS: CGFloat = 16
        static let paddingM: CGFloat = 32
        
        enum Typography {
            static let title: CGFloat = 23
            static let body: CGFloat = 13
        }
    }
}
