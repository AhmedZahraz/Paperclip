//
//  NetworkService.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

protocol NetworkService: AnyObject {
    var client: NetworkingClient { get }
    var logger: NetworkLogger? { get }

    func request<T: Decodable>(from urlRequest: URLRequest?) async throws -> T
}

class DefaultNetworkService: NetworkService {
    
    // MARK: - Properties
    var client: NetworkingClient
    var logger: NetworkLogger?

    // MARK: - Init
    public init(client: NetworkingClient,
                logger: NetworkLogger) {
        self.client = client
        self.logger = logger
    }
}

extension NetworkService {

    func request<T: Decodable>(from urlRequest: URLRequest?) async throws -> T {

        guard let urlRequest = urlRequest else {
            throw NetworkError.urlGeneration
        }

        logger?.log(request: urlRequest)
        
        do {
            let (data, response) = try await client.loadData(from: urlRequest)

            do {
                let decoder = JSONDecoder()
                logger?.log(responseData: data, response: response)
                let result = try decoder.decode(T.self, from: data)

                return result
            } catch {
                throw NetworkError.parsingJSON
            }
        } catch {
            var networkError: NetworkError
            // error raised by our do/catch statement
            if let ourError = error as? NetworkError {
                networkError = ourError
            } else if error._code == NSURLErrorNotConnectedToInternet {
                networkError = .notConnected
            } else if error._code == NSURLErrorCancelled {
                networkError = .cancelled
            } else {
                networkError = .generic(error)
            }
            logger?.log(error: error)
            throw networkError
        }
    }
}
