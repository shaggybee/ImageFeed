//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 13.04.2026.
//

@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
