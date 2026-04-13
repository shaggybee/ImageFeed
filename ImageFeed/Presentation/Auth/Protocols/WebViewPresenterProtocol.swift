//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
