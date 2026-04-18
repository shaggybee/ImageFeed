//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    var profileService: ProfileServiceSpy!
    var profileImageService: ProfileImageServiceSpy!
    var profileLogoutService: ProfileLogoutServiceSpy!
    var viewController: ProfileViewControllerSpy!
    var presenter: ProfileViewPresenter!
    
    @MainActor override func setUp() {
        super.setUp()
        
        profileService = ProfileServiceSpy()
        profileImageService = ProfileImageServiceSpy()
        profileLogoutService = ProfileLogoutServiceSpy()
        
        viewController = ProfileViewControllerSpy()
        presenter = ProfileViewPresenter(
            profileService: profileService,
            profileLogoutService: profileLogoutService,
            notificationCenter: .default,
            profileImageService: profileImageService
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    @MainActor override func tearDown() {
        profileService = nil
        profileImageService = nil
        profileLogoutService = nil
        viewController = nil
        presenter = nil
        
        super.tearDown()
    }
    
    @MainActor func testViewControllerCallViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    @MainActor func testPresenterCallsUpdateProfileOnView() {
        // given
        let bio: String? = profileService.profile?.bio
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertNotNil(viewController.profileDetails?.bio)
        XCTAssertEqual(viewController.profileDetails?.bio, bio)
    }
    
    @MainActor func testPresenterCallsUpdateAvatarOnView() {
        // given
        let avatarURL: URL? = URL(string: profileImageService.profileAvatarURL ?? "")
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertNotNil(viewController.avatarURL)
        XCTAssertEqual(viewController.avatarURL, avatarURL)
    }
    
    @MainActor func testSwitchToSplashScreenAfterLogout() {
        // when
        viewController.didTapLogout()
        
        // then
        XCTAssertTrue(viewController.isSwitchedToSplashScreen)
    }
    
    @MainActor func testUserSessionDataResetAfterLogout() {
        // when
        viewController.didTapLogout()
        
        // then
        XCTAssertTrue(profileLogoutService.isUserSessionDataReset)
    }
}
