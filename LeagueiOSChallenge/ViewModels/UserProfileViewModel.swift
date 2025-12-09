//
//  UserProfileViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

final class UserProfileViewModel {
    private let user: UserResponse
    
    var username: String {
        return user.username
    }
    
    var email: String {
        return user.email
    }
    
    var avatarURL: URL? {
        return URL(string: user.avatar)
    }
    
    init(user: UserResponse) {
        self.user = user
    }
    
    func isValidEmail() -> Bool {
        guard !email.isEmpty else {
            return false
        }
        
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(?:com|biz|net)"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email.lowercased())
    }
}
