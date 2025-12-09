//
//  UserResponse.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 05/12/2025.
//

import Foundation

// MARK: - User
struct UserResponse: Codable {
    let id: Int
    let avatar: String
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
