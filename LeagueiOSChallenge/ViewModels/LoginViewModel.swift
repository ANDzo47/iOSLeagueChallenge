//
//  LoginViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

final class LoginViewModel {
    private let service: LoginServiceProtocol
    private let userStorage: UserStorageProtocol
    
    var onLoginSuccess: ((UserPersistance) -> Void)?
    var onError: ((Error) -> Void)?

    init(service: LoginServiceProtocol = LoginService(),
         userStorage: UserStorageProtocol = UserStorage.shared) {
        self.service = service
        self.userStorage = userStorage
    }
    
    func isValid(username: String) -> Bool {
        return !username.isEmpty
    }
    
    func isValid(password: String) -> Bool {
        guard !password.isEmpty else {
            return false
        }

        return password.count >= 6
    }

    func login(username: String, password: String) {
        makeLoginRequest(
            username: username,
            password: password,
            role: .loggedIn
        )
    }
    
    func loginAsGuest() {
        makeLoginRequest(role: .guest)
    }
    
    func makeLoginRequest(username: String? = nil, password: String? = nil, role: Role) {
        Task {
            do {
                let _ = try await self.service.login(
                    username: username,
                    password: password
                )
                await MainActor.run {
                    guard let currentUser = self.userStorage.currentUser else {
                        self.onError?(APIError.decodeFailure)
                        return
                    }
                    self.onLoginSuccess?(currentUser)
                }
            } catch {
                await MainActor.run { self.onError?(error) }
            }
        }
    }
}
