//
//  ImagesListView.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 16.04.2026.
//

@testable import ImageFeed
import XCTest

final class ImagesListView: XCTestCase {
    var viewController: ImagesListViewControllerSpy!
    var presenter: ImagesListViewPresenterProtocol!
    var imagesListService: ImagesListServiceSpy!
    
    @MainActor override func setUp() {
        super.setUp()
        
        imagesListService = ImagesListServiceSpy()
        viewController = ImagesListViewControllerSpy()
        presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    @MainActor override func tearDown() {
        imagesListService = nil
        viewController = nil
        presenter = nil
        
        super.tearDown()
    }
    
    @MainActor func testViewControllerCallViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    @MainActor func testPresenterCallsShowErrorAfterLikingPhoto() {
        // when
        presenter.viewDidLoad()
        presenter.changeLike(for: imagesListService.indexPhotoWithError, {})
        
        // then
        XCTAssertEqual(imagesListService.changeLikeError, ImagesListServiceErrors.changeLikeError)
    }
    
    @MainActor func testPresenterUpdatesRangeOfTableCellsAfterFetchImages() {
        // when
        presenter.viewDidLoad()
        presenter.fetchPhotos()
        presenter.fetchPhotos()

        // then
        let lastLoadedPage = imagesListService.lastLoadedPage ?? 0
        
        let startIndex = max(0, lastLoadedPage * imagesListService.pageSize - imagesListService.pageSize)
        let endIndex = lastLoadedPage * imagesListService.pageSize
        
        XCTAssertEqual(viewController.updatedTableCellStartIndex, startIndex)
        XCTAssertEqual(viewController.updatedTableCellEndIndex, endIndex)
    }
    
    @MainActor func testPresenterCallsChangeTableCellAfterLikePhotoSuccess() {
        // given
        let indexPhoto = 8
        
        // when
        presenter.viewDidLoad()
        presenter.changeLike(for: indexPhoto, {})
        
        // then
        XCTAssertNotNil(imagesListService.photos[safe: indexPhoto]?.id)
        XCTAssertEqual(imagesListService.likedPhotoId, imagesListService.photos[safe: indexPhoto]?.id)
    }
}
