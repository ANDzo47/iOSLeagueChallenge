//
//  UserStorageMock.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class UserStorageMock: UserStorageProtocol {

    var invokedCurrentUserGetter = false
    var invokedCurrentUserGetterCount = 0
    var stubbedCurrentUser: UserPersistance!

    var currentUser: UserPersistance? {
        invokedCurrentUserGetter = true
        invokedCurrentUserGetterCount += 1
        return stubbedCurrentUser
    }

    var invokedApiKeyGetter = false
    var invokedApiKeyGetterCount = 0
    var stubbedApiKey: String!

    var apiKey: String? {
        invokedApiKeyGetter = true
        invokedApiKeyGetterCount += 1
        return stubbedApiKey
    }

    var invokedRoleGetter = false
    var invokedRoleGetterCount = 0
    var stubbedRole: Role!

    var role: Role? {
        invokedRoleGetter = true
        invokedRoleGetterCount += 1
        return stubbedRole
    }

    var invokedSave = false
    var invokedSaveCount = 0
    var invokedSaveParameters: (user: UserPersistance, Void)?
    var invokedSaveParametersList = [(user: UserPersistance, Void)]()

    func save(user: UserPersistance) {
        invokedSave = true
        invokedSaveCount += 1
        invokedSaveParameters = (user, ())
        invokedSaveParametersList.append((user, ()))
    }

    var invokedClear = false
    var invokedClearCount = 0

    func clear() {
        invokedClear = true
        invokedClearCount += 1
    }
}
