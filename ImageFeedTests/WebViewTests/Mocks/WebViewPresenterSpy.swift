//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 13.04.2026.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func getCode(from url: URL) -> String? {
        return nil
    }
}
