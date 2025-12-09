//
//  APIClient.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import Foundation

enum APIError: Error {
    case authentificationDataIncomplete
    case nonAuthenticatedRequest
    case invalidEndpoint
    case invalidParameters
    case decodeFailure
    case emptyApiKey
}

enum APIEndpoint: String {
    case login
    case users
    case posts
    
    var path: String {
        return rawValue
    }
    
    var method: String {
        // This is hardcoded because the API only supports GET requests
        return "GET"
    }
}

final class APIClient {
    static let shared = APIClient()
    private let baseURL: URL?

    init(baseURL: URL? = URL(string: "https://northamerica-northeast1-league-engineering-hiring.cloudfunctions.net/mobile-challenge-api/")) {
        self.baseURL = baseURL
    }
    
    func authenticate<T: Decodable>(username: String? = nil, password: String? = nil) async throws -> T {
        guard let url = baseURL?.appendingPathComponent(APIEndpoint.login.path) else {
            throw APIError.invalidEndpoint
        }

        let session: URLSession
        
        if let username = username, let password = password {
            let authString = "\(username):\(password)"
            let authData = Data(authString.utf8)
            let base64AuthString = "Basic \(authData.base64EncodedString())"
            let urlSessionConfig: URLSessionConfiguration = .default
            urlSessionConfig.httpAdditionalHeaders = ["Authorization": base64AuthString]
            session = URLSession(configuration: urlSessionConfig)
        } else {
            // Corroborate that there were no data filled for guest user
            guard username == nil && password == nil else {
                throw APIError.authentificationDataIncomplete
            }

            // Continue the authentification as a guest user
            session = URLSession.shared
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let (data, _) = try await session.data(for: URLRequest(url: url))

        if let results = try? decoder.decode(T.self, from: data) {
            return results
        } else {
            throw APIError.decodeFailure
        }
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, params: [String: Any] = [:]) async throws -> T {
        guard let url = baseURL?.appendingPathComponent(endpoint.path) else {
            throw APIError.invalidEndpoint
        }
        
        // Adding Query Parameters
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = params.map({ (key: String, value: Any) -> URLQueryItem in
            URLQueryItem(name: key, value: "\(value)")
        })
        
        guard let urlWithParameters = components?.url else {
            throw APIError.invalidParameters
        }
        var request =  URLRequest(url: urlWithParameters)
        request.httpMethod = endpoint.method
        
        if let apiKey = UserStorage.shared.currentUser?.apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        } else {
            throw APIError.nonAuthenticatedRequest
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let results = try? decoder.decode(T.self, from: data) {
            return results
        } else {
            throw APIError.decodeFailure
        }
    }
}
