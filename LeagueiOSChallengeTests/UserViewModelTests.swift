//
//  UserViewModelTests.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

fileprivate extension MockedData {
    static let invalidEmailUser: UserResponse = UserResponse(
        id: 1,
        avatar: "https://via.placeholder.com/150",
        name: "User",
        username: "username",
        email: "someinvalid@mail.co",
        address: MockedData.mockedAddress,
        phone: "012131231321",
        website: "www.company.com",
        company: MockedData.mockedCompany
    )
}

final class UserViewModelTests: XCTestCase {
    
    var viewModel: UserProfileViewModel!

    override func setUpWithError() throws {
        viewModel = UserProfileViewModel(user: MockedData.mockedUser)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testValidUsername() throws {
        XCTAssertEqual(viewModel.username, "username")
    }
    
    func testValidEmail() throws {
        XCTAssertTrue(viewModel.isValidEmail())
        
        viewModel = UserProfileViewModel(user: MockedData.invalidEmailUser)
        XCTAssertFalse(viewModel.isValidEmail())
    }
}
