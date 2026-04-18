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

    @MainActor func testPresenterReturnsErrorWhenLikePhotoFails() {
        // when
        presenter.viewDidLoad()
        presenter.changeLike(for: imagesListService.indexPhotoWithError, {})
        
        // then
        XCTAssertEqual(imagesListService.changeLikeError, ImagesListServiceErrors.changeLikeError)
    }
    
    @MainActor func testPresenterCallsUpdateTableViewAnimatedAfterFetchImages() {
        // when
        presenter.viewDidLoad()
        presenter.fetchPhotos()
        presenter.fetchPhotos()

        // then
        let startIndex = max(0, presenter.photosCount - imagesListService.pageSize)
        let endIndex = presenter.photosCount
        
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
    
    @MainActor func testPresenterReturnLargeImageURLForCell() {
        // given
        let indexPhoto = 4
        
        // when
        presenter.viewDidLoad()
        
        //then
        let photoUrl = URL(string: presenter.photos[safe: indexPhoto]?.largeImageURL ?? "")
        
        XCTAssertNotNil(photoUrl)
        XCTAssertEqual(photoUrl, presenter.getLargeImageURL(for: indexPhoto))
    }
}
