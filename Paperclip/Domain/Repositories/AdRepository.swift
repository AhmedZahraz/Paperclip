//
//  AdRepository.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 13/02/2023.
//

import Foundation

protocol AdRepository {
    func getAd(with id: Int64) async throws -> Ad
    func fetchAdsList(offset: Int, limit: Int) async throws -> [Ad]
}
