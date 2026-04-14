//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    var viewController: ProfileViewControllerSpy!
    var presenter: ProfileViewPresenterSpy!
    var profileLogoutService: ProfileLogoutServiceSpy!
    
    override func setUp() {
        super.setUp()
        
        profileLogoutService = ProfileLogoutServiceSpy()
        viewController = ProfileViewControllerSpy()
        presenter = ProfileViewPresenterSpy(
            profileService: ProfileServiceSpy(),
            profileLogoutService: profileLogoutService,
            notificationCenter: .default,
            profileImageService: ProfileImageServiceSpy()
        )
    }
    
    @MainActor func testViewControllerCallViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    @MainActor func testPresenterCallsUpdateProfileOnView() {
        // given
        let profileService = ProfileServiceSpy()
        let bio: String? = profileService.profile?.bio
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertNotNil(viewController.profileDetails?.bio)
        XCTAssertEqual(viewController.profileDetails?.bio, bio)
    }
    
    @MainActor func testPresenterCallsUpdateAvatartOnView() {
        // given
        let profileImageService = ProfileImageServiceSpy()
        let avatarURL: URL? = URL(string: profileImageService.profileAvatarURL ?? "")
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertNotNil(viewController.avatarURL)
        XCTAssertEqual(viewController.avatarURL, avatarURL)
    }
    
    @MainActor func testSwitchToSplashScreenAfterLogout() {
        // given
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.logout()
        
        // then
        XCTAssertTrue(viewController.isSwitchedToSplashScreen)
    }
    
    @MainActor func testUserSessionDataResetAfterLogout() {
        // given
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.logout()
        
        // then
        XCTAssertTrue(profileLogoutService.isUserSessionDataReset)
    }
}
