//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 12.04.2026.
//

import Foundation

protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    func getCode(from url: URL) -> String?
}
