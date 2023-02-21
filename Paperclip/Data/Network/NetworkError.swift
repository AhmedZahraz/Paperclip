//
//  NetworkError.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

public enum NetworkError: Error {
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case parsingJSON
}
