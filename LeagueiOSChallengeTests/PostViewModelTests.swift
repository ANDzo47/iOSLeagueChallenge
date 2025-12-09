//
//  PostViewModelTests.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class PostViewModelTests: XCTestCase {
    
    var viewModel: PostListViewModel!
    var postServiceMock = PostServiceMock()
    var userServiceMock = UserServiceMock()
    var userStorageMock = UserStorageMock()

    override func setUpWithError() throws {
        viewModel = PostListViewModel(
            postService: postServiceMock,
            userService: userServiceMock,
            userStorage: userStorageMock
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testIsGuestUser() throws {
        userStorageMock.stubbedCurrentUser = .init(role: .guest, apiKey: "API-KEY-1")
        XCTAssertTrue(viewModel.isGuestUser)
        
        userStorageMock.stubbedCurrentUser = .init(role: .loggedIn, apiKey: "API-KEY-1")
        XCTAssertFalse(viewModel.isGuestUser)
    }
    
    func testReload() throws {
        
        viewModel.reload()
        
        let expectation = expectation(description: "Waiting Posts Response")
        
        viewModel.onUpdate = {
            XCTAssertTrue(self.postServiceMock.invokedFetchPosts)
            XCTAssertTrue(self.userServiceMock.invokedFetchUsers)
            
            expectation.fulfill()
        }

        viewModel.onError = { error in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
        
    func testPostAt() throws {
        postServiceMock.stubbedFetchPostsResult = MockedData.posts
        userServiceMock.stubbedFetchUsersResult = MockedData.users
        
        viewModel.reload()
        
        let expectation = expectation(description: "Waiting Posts Response")
        
        viewModel.onUpdate = {
            XCTAssertEqual(self.viewModel.post(at: IndexPath(row: 0, section: 0)).userId, 1)
            XCTAssertEqual(self.viewModel.post(at: IndexPath(row: 1, section: 0)).userId, 1)
            XCTAssertEqual(self.viewModel.post(at: IndexPath(row: 2, section: 0)).userId, 2)
            XCTAssertEqual(self.viewModel.post(at: IndexPath(row: 3, section: 0)).userId, 3)
            
            expectation.fulfill()
        }

        viewModel.onError = { error in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
        
    }
    
    func testUserFor() throws {
        postServiceMock.stubbedFetchPostsResult = MockedData.posts
        userServiceMock.stubbedFetchUsersResult = MockedData.users
        
        viewModel.reload()
        
        let expectation = expectation(description: "Waiting Posts Response")

        viewModel.onUpdate = {
            XCTAssertEqual(self.viewModel.user(for: self.viewModel.post(at: IndexPath(row: 0, section: 0)))?.id, 1)
            XCTAssertEqual(self.viewModel.user(for: self.viewModel.post(at: IndexPath(row: 1, section: 0)))?.id, 1)
            XCTAssertEqual(self.viewModel.user(for: self.viewModel.post(at: IndexPath(row: 2, section: 0)))?.id, 2)
            XCTAssertEqual(self.viewModel.user(for: self.viewModel.post(at: IndexPath(row: 3, section: 0)))?.id, 3)
            
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
        
    func testClearUser() throws {
        UserStorage.shared.save(user: UserPersistance(role: .loggedIn, apiKey: "API-KEY"))
        
        viewModel = PostListViewModel(
            postService: postServiceMock,
            userService: userServiceMock,
            userStorage: UserStorage.shared
        )
        
        XCTAssertFalse(viewModel.isGuestUser)
        
        viewModel.clearUser()
        
        XCTAssertTrue(viewModel.isGuestUser)
    }
}
