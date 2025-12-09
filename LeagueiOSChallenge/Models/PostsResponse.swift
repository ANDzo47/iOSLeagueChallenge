//
//  PostsResponse.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 05/12/2025.
//

import Foundation

// MARK: - Post
struct PostsResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
