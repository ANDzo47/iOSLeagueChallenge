//
//  UserPersistance.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation
import Security

protocol UserStorageProtocol {
    var currentUser: UserPersistance? { get }
    var apiKey: String? { get }
    var role: Role? { get }
    
    func save(user: UserPersistance)
    func clear()
}

// I used keychain instead of UserDefaults in order to have more security
// on the data persisted in the app since the apiKey is a sensitive data.
final class UserStorage: UserStorageProtocol {
    
    static let shared = UserStorage()

    private let serviceName = "com.LeagueiOSChallenge.userstorage"

    private let userKey = "user_key"

    private init() {}

    var currentUser: UserPersistance? {
        guard let data = readKeychainData(account: userKey) else { return nil }
        return try? JSONDecoder().decode(UserPersistance.self, from: data)
    }

    var apiKey: String? {
        guard let user = currentUser else { return nil }
        return user.apiKey
    }
    
    var role: Role? {
        guard let user = currentUser else { return nil }
        return user.role
    }

    func save(user: UserPersistance) {
        if let userData = try? JSONEncoder().encode(user) {
            saveKeychain(data: userData, account: userKey)
        }
    }

    func clear() {
        deleteKeychainItem(account: userKey)
    }

    // MARK: - Keychain helpers

    private func keychainQuery(account: String) -> [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: serviceName,
         kSecAttrAccount as String: account]
    }

    private func saveKeychain(data: Data, account: String) {
        var query = keychainQuery(account: account)
        
        // Try update first
        let updateStatus = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if updateStatus == errSecSuccess {
            return
        }
        
        // If update failed because item doesn't exist, add it
        query[kSecValueData as String] = data
        
        // Default accessibility
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(query as CFDictionary, nil)
    }

    private func readKeychainData(account: String) -> Data? {
        var query = keychainQuery(account: account)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        return result as? Data
    }

    private func deleteKeychainItem(account: String) {
        let query = keychainQuery(account: account)
        SecItemDelete(query as CFDictionary)
    }
}
