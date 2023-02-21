//
//  NetworkLogger.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

public protocol NetworkLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

final public class DefaultNetworkLogger: NetworkLogger {
    public init() { }

    public func log(request: URLRequest) {
        #if DEBUG
        print("#######\u{1F37A}\u{1F37A}\u{1F37A}\u{1F37A}  REQUEST   \u{1F37A}\u{1F37A}\u{1F37A}\u{1F37A}#######")
        if let url = request.url {
            print("request: \(url)")
        }
        if let allHTTPHeaderFields = request.allHTTPHeaderFields {
            print("headers: \(allHTTPHeaderFields)")
        }
        if let httpMethod = request.httpMethod {
            print("method: \(httpMethod)")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        #if DEBUG
        guard let data = data else { return }
        if let dataDict =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("#######\u{1F643}\u{1F643}\u{1F643}\u{1F643}  RESPONSE  \u{1F643}\u{1F643}\u{1F643}\u{1F643}#######")
            print("responseData: \(String(describing: dataDict))")
            print("#######\u{1F60D}\u{1F60D}\u{1F60D}\u{1F60D}  RESPONSE  \u{1F60D}\u{1F60D}\u{1F60D}\u{1F60D}#######")
            print("responseData: \(String(describing: dataDict))")
        }
        #endif
    }

    public func log(error: Error) {
        #if DEBUG
        print("#######\u{1F62D}\u{1F62D}\u{1F62D}\u{1F62D}  ERROR     \u{1F62D}\u{1F62D}\u{1F62D}\u{1F62D}#######")
        print("error: \(error)")
        #endif
    }
}
