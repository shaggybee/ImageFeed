//
//  OAuth2TokenStorageProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 27.02.2026.
//

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
    func reset()
}
