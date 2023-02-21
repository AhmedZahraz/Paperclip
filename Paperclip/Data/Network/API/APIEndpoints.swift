//
//  APIEndpoints.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

struct APIEndpoints {
    
    enum HTTPMethodType: String {
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case delete  = "DELETE"
        case patch   = "PATCH"
    }
    
    static func getAds() throws -> URLRequest {
        return try urlRequest(with: NetworkConfig.API_PAPERCLIP_BASE_URL,
                          endpoint: NetworkConfig.API_ADS_LIST_ENDPOINT)
    }
 
    static func getCategories() throws -> URLRequest {
        return try urlRequest(with: NetworkConfig.API_PAPERCLIP_BASE_URL,
                          endpoint: NetworkConfig.API_CATEGORIES_LIST_ENDPOINT)
    }
    
    static func urlRequest(with baseUrl: String,
                                endpoint: String,
                                httpMethod: HTTPMethodType = .get,
                                headerParamaters: [String: String] = [:] ,
                                bodyParamaters: [String: Any] = [:]) throws -> URLRequest {

        guard let baseURL = URL(string: baseUrl.appending(endpoint)) else {
            throw NetworkError.urlGeneration
        }

        var urlRequest = URLRequest(url: baseURL)
        let allHeaders: [String: String] = headerParamaters

        if !bodyParamaters.isEmpty {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParamaters)
        }
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    fileprivate func url(with baseURL: String, endpoint: String) -> URL? {
        let url = baseURL.appending(endpoint)
        return URL(string: url)
    }
}
