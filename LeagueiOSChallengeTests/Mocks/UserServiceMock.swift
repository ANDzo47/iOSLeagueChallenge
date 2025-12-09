//
//  UserServiceMock.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class UserServiceMock: UserServiceProtocol {
    var invokedFetchUsers = false
    var invokedFetchUsersCount = 0
    var stubbedFetchUsersResult: [UserResponse] = []
    var stubbedFetchUsersFailureResult: APIError?

    func fetchUsers() async throws -> [UserResponse] {
        invokedFetchUsers = true
        invokedFetchUsersCount += 1
        if let stubbedFetchUsersFailureResult = stubbedFetchUsersFailureResult {
            throw stubbedFetchUsersFailureResult
        } else {
            return stubbedFetchUsersResult
        }
    }

    var invokedFetchUser = false
    var invokedFetchUserCount = 0
    var invokedFetchUserParameters: (id: String, Void)?
    var invokedFetchUserParametersList = [(id: String, Void)]()
    var stubbedFetchUserResult: UserResponse?
    var stubbedFetchUserFailureResult: APIError?

    func fetchUser(withId id: String) async throws -> UserResponse {
        invokedFetchUser = true
        invokedFetchUserCount += 1
        invokedFetchUserParameters = (id, ())
        invokedFetchUserParametersList.append((id, ()))
        if let stubbedFetchUserResult = stubbedFetchUserResult {
            return stubbedFetchUserResult
        } else {
            throw stubbedFetchUserFailureResult ?? APIError.decodeFailure
        }
    }
}
