//
//  URLSession+Networker.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 13/02/2023.
//

import Foundation

extension URLSession: NetworkingClient {
    
    func loadData(from request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await self.data(for: request)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let task = self.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: (data, response))
                }
                task.resume()
            }
        }
    }
    
}
