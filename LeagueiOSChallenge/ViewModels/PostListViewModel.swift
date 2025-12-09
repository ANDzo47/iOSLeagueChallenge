//
//  PostListViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation

final class PostListViewModel {
    private let postService: PostServiceProtocol
    private let userService: UserServiceProtocol
    private let userStorage: UserStorageProtocol
    
    private(set) var posts: [PostsResponse] = []
    private(set) var users: [UserResponse] = []
    
    var isGuestUser: Bool {
        return userRole == .guest
    }
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
        
    private var userRole: Role {
        return userStorage.currentUser?.role ?? .guest
    }
    
    init(postService: PostServiceProtocol = PostService(),
         userService: UserServiceProtocol = UserService(),
         userStorage: UserStorageProtocol = UserStorage.shared) {
        self.postService = postService
        self.userService = userService
        self.userStorage = userStorage
    }
    
    func reload() {
        fetch()
    }
    
    func post(at indexPath: IndexPath) -> PostsResponse {
        return posts[indexPath.row]
    }
    
    func user(for post: PostsResponse) -> UserResponse? {
        return users.first { $0.id == post.userId }
    }
    
    func clearUser() {
        userStorage.clear()
    }

    private func fetch() {
        Task {
            do {
                let posts = try await postService.fetchPosts()
                let users = try await userService.fetchUsers()

                await MainActor.run {
                    self.posts = posts
                    self.users = users
                    self.onUpdate?()
                }
            } catch {
                await MainActor.run {
                    self.onError?(error)
                }
            }
        }
    }
}
