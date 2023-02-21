//
//  GetAdsWithCategoriesUseCase.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 14/02/2023.
//

import Foundation

protocol GetAdsWithCategoriesUseCase {
    func execute(offset: Int, limit: Int) async throws -> [Ad]
}

final class DefaultGetAdsWithCategoriesUseCase: GetAdsWithCategoriesUseCase {

    private let adRepository: AdRepository
    private let categoryRepository: CategoryRepository

    init(adRepository: AdRepository,
         categoryRepository: CategoryRepository) {
        self.adRepository = adRepository
        self.categoryRepository = categoryRepository
    }

    func execute(offset: Int, limit: Int) async throws -> [Ad] {
        return try await adRepository.fetchAdsList(offset: offset, limit: limit)
    }
}
