//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 13.04.2026.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    @MainActor func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()

        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    @MainActor func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())

        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    @MainActor func testProgressVisibleWhenLessThenOne() {
        // given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    @MainActor func testProgressHiddenWhenOne() {
        // given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 1
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }
    
    @MainActor func testCodeFromURL() throws {
        //given
        var urlComponents = try XCTUnwrap(URLComponents(string: "https://unsplash.com/oauth/authorize/native"), "[testCodeFromURL] failed to get URLComponents")
        urlComponents.queryItems = [
            URLQueryItem(
                name: AuthorizationConstants.QueryItem.code,
                value: AuthorizationConstants.QueryItemValue.authorizationCode)
        ]
        let url = try XCTUnwrap(urlComponents.url, "[testCodeFromURL] failed to get URL")
        let helper = AuthHelper()
        
        // when
        let code = helper.getCode(from: url)
    
        // then
        XCTAssertEqual(code, AuthorizationConstants.QueryItemValue.authorizationCode)
    }
}
