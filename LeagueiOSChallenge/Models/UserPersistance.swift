//
//  UserPersistance.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

enum Role: String, Codable {
    case loggedIn
    case guest
}

struct UserPersistance: Codable {
    var role: Role
    var apiKey: String
}
