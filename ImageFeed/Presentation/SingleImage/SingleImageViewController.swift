//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 08.02.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Public properties
    var image: UIImage? {
        didSet {
            guard let image, isViewLoaded else { return }

            configImageView(image)
            rescaleImageInScrollView(image)
            setCenterForImageInScrollView()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configScrollView()
        
        guard let image else { return }
        
        configImageView(image)
        rescaleImageInScrollView(image)
        setCenterForImageInScrollView()
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        
        let shareSheet = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareSheet, animated: true)
    }

    // MARK: - Private methods
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
