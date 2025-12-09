//
//  ImageLoader.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = URLCache()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func load(url: URL) async -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedData = cache.cachedResponse(for: request)?.data,
           let image = UIImage(data: cachedData) {
            return image
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
            return image
        } catch {
            return nil
        }
    }
}
