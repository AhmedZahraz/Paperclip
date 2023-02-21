//
//  NetworkingClient.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 13/02/2023.
//

import Foundation

protocol NetworkingClient {
    func loadData(from request: URLRequest) async throws -> (Data, URLResponse)
}
