//
//  PostServiceMock.swift
//  LeagueiOSChallengeTests
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class PostServiceMock: PostServiceProtocol {
    var invokedFetchPosts = false
    var invokedFetchPostsCount = 0
    var stubbedFetchPostsResult: [PostsResponse] = []
    var stubbedFetchPostsFailureResult: APIError?

    func fetchPosts() async throws -> [PostsResponse] {
        invokedFetchPosts = true
        invokedFetchPostsCount += 1
        if let stubbedFetchPostsFailureResult = stubbedFetchPostsFailureResult {
            throw stubbedFetchPostsFailureResult
        } else {
            return stubbedFetchPostsResult
        }
    }
}
