//
//  NetworkingClientMock.swift
//  PaperclipTests
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import Foundation

struct NetworkingClientMock: NetworkingClient {
    
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func loadData(from request: URLRequest) async throws -> (Data, URLResponse) {
        return (data!, response!)
    }
}
