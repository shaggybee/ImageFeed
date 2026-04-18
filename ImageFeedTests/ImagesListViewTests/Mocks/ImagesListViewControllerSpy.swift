//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 16.04.2026.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    var updatedTableCellStartIndex: Int?
    var updatedTableCellEndIndex: Int?
    
    func updateTableViewAnimated(from indexStart: Int, to indexEnd: Int) {
        updatedTableCellStartIndex = indexStart
        updatedTableCellEndIndex = indexEnd
    }
    
    func changeLikedStateForCell(by index: Int, isLike: Bool) { }
    
    func showErrorAlert(for isLike: Bool) { }
}
