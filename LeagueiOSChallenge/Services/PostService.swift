//
//  PostService.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

protocol PostServiceProtocol {
    func fetchPosts() async throws -> [PostsResponse]
}

final class PostService: PostServiceProtocol {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchPosts() async throws -> [PostsResponse] {
        return try await client.request(APIEndpoint.posts)
    }
}
