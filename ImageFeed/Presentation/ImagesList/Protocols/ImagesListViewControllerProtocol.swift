//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 15.04.2026.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set  }
    func updateTableViewAnimated(from indexStart: Int, to indexEnd: Int)
    func changeLikedStateForCell(by index: Int, isLike: Bool)
    func showErrorAlert(for isLike: Bool)
}
