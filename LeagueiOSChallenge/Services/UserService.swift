//
//  UserService.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [UserResponse]
    func fetchUser(withId id: String) async throws -> UserResponse
}

final class UserService: UserServiceProtocol {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchUsers() async throws -> [UserResponse] {
        return try await client.request(APIEndpoint.users)
    }
    
    func fetchUser(withId id: String) async throws -> UserResponse {
        return try await client.request(APIEndpoint.users, params: ["userId": id])
    }
}
