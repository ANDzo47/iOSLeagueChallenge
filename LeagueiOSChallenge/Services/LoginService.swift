//
//  LoginService.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

protocol LoginServiceProtocol {
    func login(username: String?, password: String?) async throws -> LoginResponse
}

final class LoginService: LoginServiceProtocol {
    private let client: APIClient
    private let persistence: UserStorage

    init(client: APIClient = .shared, persistence: UserStorage = .shared) {
        self.client = client
        self.persistence = persistence
    }

    func login(username: String?, password: String?) async throws -> LoginResponse {
        let loginResponse: LoginResponse = try await client.authenticate(username: username, password: password)
        
        guard !loginResponse.apiKey.isEmpty else {
            throw APIError.emptyApiKey
        }
        
        let role: Role = (username == nil && password == nil) ? .guest : .loggedIn
        persistence.save(user: UserPersistance(role: role, apiKey: loginResponse.apiKey))

        return loginResponse
    }
}
