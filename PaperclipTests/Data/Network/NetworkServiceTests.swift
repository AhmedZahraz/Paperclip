//
//  NetworkServiceTests.swift
//  PaperclipTests
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    func test_whenMockDataPassed_shouldReturnProperResponse() async {
        //given
        let expectedResponseData = User.mockJson().data(using: .utf8)!
        let expectedResponse: User? = try? JSONDecoder().decode(User.self, from: expectedResponseData)
        let expectedHTTPURLResponse = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: nil)!

        let sut = DefaultNetworkService(client: NetworkingClientMock(response: expectedHTTPURLResponse,
                                                                     data: expectedResponseData,
                                                                     error: nil),
                                        logger: DefaultNetworkLogger())

        // when
        do {
            let responseData: User = try await sut.request(from: .init(url: URL(string: "test_url")!))
            // then
            XCTAssertEqual(responseData, expectedResponse)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() async {
        // given
        let expectedResponseData = #"{"age": 20}"#.data(using: .utf8)!
        let expectedHTTPURLResponse = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: nil)!
        let sut = DefaultNetworkService(client: NetworkingClientMock(response: expectedHTTPURLResponse,
                                                                     data: expectedResponseData,
                                                                     error: nil),
                                        logger: DefaultNetworkLogger())

        // when
        do {
            let _: User = try await sut.request(from: .init(url: URL(string: "test_url")!))
            // then
            XCTFail("Should not happen")
        } catch {
            if case NetworkError.parsingJSON = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error")
            }
        }
    }
    
    struct User: Codable, Equatable {
        let id: Int
        let name: String
        let email: String

        static func mockJson() -> String {
            let jsonString = """
            {"id": 1, "name": "Alice", "email": "alice@example.com"}
            """
            return jsonString
        }
        
        static func mockJsonArray() -> String {
            let jsonString = """
            [
                {"id": 1, "name": "Alice", "email": "alice@example.com"},
                {"id": 2, "name": "Bob", "email": "bob@example.com"},
                {"id": 3, "name": "Alice", "email": "alice@example.com"},
                {"id": 4, "name": "Bob", "email": "bob@example.com"},
                {"id": 5, "name": "Alice", "email": "alice@example.com"},
                {"id": 6, "name": "Bob", "email": "bob@example.com"}
            ]
            """
            return jsonString
        }
    }
}
