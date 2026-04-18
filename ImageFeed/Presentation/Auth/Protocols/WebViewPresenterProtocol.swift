//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func getCode(from url: URL) -> String?
}
