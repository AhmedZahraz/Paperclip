//
//  CategoryRepository.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 14/02/2023.
//

import Foundation

protocol CategoryRepository {
    func fetchCategoriesList() async throws -> [Category]
}
