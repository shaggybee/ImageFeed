//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 08.02.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public properties
    var image: UIImage? {
        didSet {
            guard let image, isViewLoaded else { return }

            configImageView(image)
            rescaleImageInScrollView(image)
            setCenterForImageInScrollView()
        }
    }

    // MARK: - Private properties
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        
        return scrollView
    }().forAutoLayout
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }().forAutoLayout
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .clear
        button.setImage(.backward, for: .normal)
        
        button.addTarget(
            self,
            action: #selector(didTapBackward),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var sharingButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .ypBlack
        button.setImage(.shareButton, for: .normal)
        button.layer.cornerRadius = Constants.sharingButtonSize / 2
        button.clipsToBounds = true
        
        button.addTarget(
            self,
            action: #selector(didTapSharingImage),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        
        guard let image else { return }
        
        configImageView(image)
        rescaleImageInScrollView(image)
        setCenterForImageInScrollView()
    }
    
    // MARK: - Private methods
    @objc private func didTapBackward() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSharingImage(_ sender: Any) {
        guard let image else { return }
        
        let shareSheet = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareSheet, animated: true)
    }
    
    private func setElements() {
        view.backgroundColor = .ypBlack
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(backwardButton)
        view.addSubview(sharingButton)
        
        configScrollView()
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            sharingButton.heightAnchor.constraint(equalToConstant: Constants.sharingButtonSize),
            sharingButton.widthAnchor.constraint(equalToConstant: Constants.sharingButtonSize),
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.paddingS),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backwardButton.heightAnchor.constraint(equalToConstant: Constants.backwardButtonSize),
            backwardButton.widthAnchor.constraint(equalToConstant: Constants.backwardButtonSize),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingXS),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingXS),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func configImageView(_ image: UIImage) {
        imageView.image = image
        imageView.frame.size = image.size
    }
    
    private func rescaleImageInScrollView(_ image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()

        let heightScale = scrollView.bounds.size.height / image.size.height
        let widthScale = scrollView.bounds.size.width / image.size.width
        let scale = min(maxZoomScale, max(minZoomScale, min(heightScale, widthScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    private func setCenterForImageInScrollView() {
        let insetX = max(0, (scrollView.bounds.size.width - scrollView.contentSize.width) / 2)
        let insetY = max(0, (scrollView.bounds.size.height - scrollView.contentSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(
            top: insetY,
            left: insetX,
            bottom: insetY,
            right: insetX)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        setCenterForImageInScrollView()
    }
}

// MARK: - Constants
private extension SingleImageViewController {
    enum Constants {
        static let sharingButtonSize: CGFloat = 50
        static let backwardButtonSize: CGFloat = 44
        static let paddingXS: CGFloat = 8
        static let paddingS: CGFloat = 16
    }
}
