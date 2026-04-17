//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Kislov Vadim on 17.04.2026.
//

@testable import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        let loginButton = app.buttons[Constants.Identifiers.Auth.loginButton]
        
        expectationExistenceState(for: loginButton)
        
        loginButton.tap()
        
        let webView = app.webViews[Constants.Identifiers.Auth.webView]
        
        expectationExistenceState(for: webView, timeout: Constants.longTimeout)
        
        webView.swipeUp()
        
        let loginTextField = webView.descendants(matching: .textField).element
        
        expectationExistenceState(for: loginTextField)
        
        loginTextField.tap()
        loginTextField.typeText(Constants.login)
        
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        expectationExistenceState(for: passwordTextField)
        
        passwordTextField.tap()
        passwordTextField.typeText(Constants.password)
        
        webView.tap()
        webView.swipeUp()
        
        let webViewLoginButton = webView.buttons[Constants.Identifiers.Auth.webViewLoginButton]
        
        webViewLoginButton.tap()
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        
        expectationExistenceState(for: cell, timeout: Constants.longTimeout)
    }
    
    func testFeed() throws {
        let table = app.tables
        
        let cell = table.children(matching: .cell).element(boundBy: 0)
        
        expectationExistenceState(for: cell)
        
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = table.children(matching: .cell).element(boundBy: 1)
        
        let isCellLiked = cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOn].exists
        
        if isCellLiked {
            cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOn].tap()
            
            let button = cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOff]
            expectationExistenceState(for: button, timeout: Constants.longTimeout)
            
            button.tap()
            
            expectationExistenceState(for: cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOn])
        } else {
            cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOff].tap()
            
            let button = cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOn]
            expectationExistenceState(for: button, timeout: Constants.longTimeout)
            
            button.tap()
            
            expectationExistenceState(for: cellToLike.buttons[Constants.Identifiers.ImageList.buttonWithLikeOff])
        }
        
        cellToLike.tap()
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 1.25, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons[Constants.Identifiers.ImageList.backwardButton]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        let tabBars = app.tabBars
        tabBars.buttons.element(boundBy: 1).tap()

        let fullName = app.staticTexts[Constants.fullName]
        expectationExistenceState(for: fullName)

        let userName = app.staticTexts[Constants.userName]
        expectationExistenceState(for: userName)

        let logoutButton = app.buttons[Constants.Identifiers.Profile.exitButton]
        XCTAssertTrue(logoutButton.exists)
        logoutButton.tap()
        
        let alert = app.alerts[Constants.Identifiers.Profile.alert]
        
        expectationExistenceState(for: alert)
        
        alert.buttons.element(boundBy: 1).tap()
        
        let loginButton = app.buttons[Constants.Identifiers.Auth.loginButton]
        
        expectationExistenceState(for: loginButton)
    }
    
    private func expectationExistenceState(
        for element: XCUIElement,
        isExists: Bool = true,
        timeout: Double = Constants.timeout
    ) {
        let predicate = NSPredicate(format: "exists == \(isExists)")
        
        expectation(
            for: predicate,
            evaluatedWith: element)
        
        waitForExpectations(timeout: timeout)
    }
}

private extension ImageFeedUITests {
    enum Constants {
        static let timeout: Double = 5
        static let longTimeout: Double = 15
        static let login: String = ""
        static let password: String = ""
        static let fullName: String = ""
        static let userName: String = ""
        
        enum Identifiers {
            enum Auth {
                static let loginButton = "loginButton"
                static let webView = "UnsplashWebView"
                static let webViewLoginButton = "Login"
            }
            
            enum ImageList {
                static let backwardButton = "backward"
                static let buttonWithLikeOn = "buttonWithLikeOn"
                static let buttonWithLikeOff = "buttonWithLikeOff"
            }
            
            enum Profile {
                static let exitButton = "exit"
                static let alert = "logoutAlert"
            }
        }
    }
}
