//
//  DefaultCategoryRepository.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import Foundation

final class DefaultCategoryRepository: CategoryRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCategoriesList() async throws -> [Category] {
        do {
            let urlRequest = try APIEndpoints.getCategories()
            let categoriesDTO: [CategoryDTO] = try await self.networkService.request(from: urlRequest)
            
            return categoriesDTO.map{ $0.toDomain() }
        } catch {
            throw error
        }
    }
}
