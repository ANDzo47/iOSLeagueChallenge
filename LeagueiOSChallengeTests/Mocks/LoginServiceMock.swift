//
//  LoginServiceMock.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class LoginServiceMock: LoginServiceProtocol {
    var invokedLogin = false
    var invokedLoginCount = 0
    var invokedLoginParameters: (username: String?, password: String?)?
    var invokedLoginParametersList = [(username: String?, password: String?)]()
    var stubbedLoginResult: LoginResponse = .init(apiKey: "")
    var stubbedLoginFailureResult: APIError?
    
    var stubbedUserStorage: UserStorageProtocol?
    
    func login(username: String?, password: String?) async throws -> LoginResponse {
        invokedLogin = true
        invokedLoginCount += 1
        invokedLoginParameters = (username, password)
        invokedLoginParametersList.append((username, password))
        if let stubbedLoginFailureResult = stubbedLoginFailureResult {
            throw stubbedLoginFailureResult
        } else {
            if let stubbedUserStorage = stubbedUserStorage {
                let role: Role = username == nil && password == nil ? .guest : .loggedIn
                stubbedUserStorage.save(user: .init(
                    role: role,
                    apiKey: stubbedLoginResult.apiKey)
                )
            }
            return stubbedLoginResult
        }
    }
}
