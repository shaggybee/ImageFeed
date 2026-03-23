//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 09.03.2026.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else
        {
            assertionFailure("Invalid window configuration")
            
            return nil
        }
        
        return window
    }
    
    private init() {}
    
    static func configProgressHUD() {
        ProgressHUD.mediaSize = Constants.progressIndicatorMediaSize
        ProgressHUD.marginSize = Constants.progressIndicatorMarginSize
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.colorHUD = .ypWhite
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

// MARK: - Constants
private extension UIBlockingProgressHUD {
    enum Constants {
        static let progressIndicatorMediaSize: CGFloat = 25
        static let progressIndicatorMarginSize: CGFloat = 13
    }
}
