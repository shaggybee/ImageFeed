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
    
    // MARK: - Public properties
    var image: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    // MARK: - IBAction
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
