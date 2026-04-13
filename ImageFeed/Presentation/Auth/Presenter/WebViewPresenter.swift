//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public properties
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        
        view?.setProgressValue(newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - Constants.maxProgress) <= Constants.precisionOfProgressCompare
    }
}

// MARK: - Constants
private extension WebViewPresenter {
    enum Constants {
        static let precisionOfProgressCompare: Float = 0.0001
        static let maxProgress: Float = 1.0
    }
}
