//
//  LoginViewModelTests.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var loginServiceMock: LoginServiceMock = LoginServiceMock()
    var userStorage: UserStorage = .shared

    override func setUpWithError() throws {
        loginServiceMock.stubbedUserStorage = userStorage
        viewModel = LoginViewModel(
            service: loginServiceMock,
            userStorage: userStorage
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        userStorage.clear()
    }

    func testValidEmail() throws {
        XCTAssertTrue(viewModel.isValid(username: "MyUser"))
        XCTAssertFalse(viewModel.isValid(username: ""))
    }
    
    func testValidPassword() throws {
        XCTAssertTrue(viewModel.isValid(password: "Password-1234"))
        XCTAssertFalse(viewModel.isValid(password: "Pass"))
        XCTAssertFalse(viewModel.isValid(password: ""))
    }
    
    func testLoginServiceAsLoggedUser() throws {
        loginServiceMock.stubbedLoginResult = .init(apiKey: "apiKey-1234")

        viewModel.login(username: "MyUser", password: "Pass1234")
        
        let expectation = expectation(description: "Waiting Login Response")
        
        viewModel.onLoginSuccess = { user in
            XCTAssertTrue(self.loginServiceMock.invokedLogin)
            XCTAssertTrue(self.userStorage.currentUser?.role == .loggedIn)
            XCTAssertTrue(self.userStorage.apiKey == "apiKey-1234")
            
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testLoginServiceAsGuestUser() throws {
        loginServiceMock.stubbedLoginResult = .init(apiKey: "apiKey-GUEST")

        viewModel.loginAsGuest()
        
        let expectation = expectation(description: "Waiting Login Response")
        
        viewModel.onLoginSuccess = { user in
            XCTAssertTrue(self.loginServiceMock.invokedLogin)
            XCTAssertTrue(self.userStorage.currentUser?.role == .guest)
            XCTAssertTrue(self.userStorage.apiKey == "apiKey-GUEST")
            
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            XCTFail("Error: \(error)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
