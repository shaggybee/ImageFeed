//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Kislov Vadim on 14.04.2026.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    // MARK: - Public properties
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    // MARK: - Public methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() { }
    
    func logout() { }
}
