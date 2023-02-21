//
//  DefaultAdRepository.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation
import CoreData

final class DefaultAdRepository: AdRepository {
    
    private let networkService: NetworkService
    private let categoryRepository: CategoryRepository
    private let coreDateService: CoreDateService
    
    init(networkService: NetworkService,
         coreDateService: CoreDateService,
         categoryRepository: CategoryRepository) {
        self.networkService = networkService
        self.categoryRepository = categoryRepository
        self.coreDateService = coreDateService
    }
    
    func getAd(with id: Int64) async throws -> Ad {
        //return try await coreDateService.get(for: AdEntity.self, id: id)
        
        return try await coreDateService.performBackgroundTask { [weak self] context in
            try self!.coreDateService.get(for: AdEntity.self, id: id, context: context)
        }
    }
    
    func fetchAdsList(offset: Int, limit: Int) async throws -> [Ad] {
        if offset == 0 {
            try await fetchAndStoreAdsList()
        }
        return try await fetchStoredAdsList(offset: offset, limit: limit)
    }
    
    private func fetchAndStoreAdsList() async throws {
        let categories = try await categoryRepository.fetchCategoriesList()
        
        let urlRequest = try APIEndpoints.getAds()
        let adsDTO: [AdDTO] = try await self.networkService.request(from: urlRequest)
        
        try await storeAdsList(adsDTO: adsDTO, categories: categories)
    }
    
    private func storeAdsList(adsDTO: [AdDTO], categories: [Category]) async throws {
        return try await coreDateService.performBackgroundTask { [weak self] context in
            
            try self?.coreDateService.clear(AdEntity.self, context: context)
            
            let categoryEntityDictionary: [Int64: CategoryEntity] = Dictionary(uniqueKeysWithValues: categories.compactMap { category in
                return (category.id, CategoryEntity(category: category, insertInto: context))
            })
            
            for (index, ad) in adsDTO.enumerated() {
                if let categoryID = ad.categoryID, let categoryEntity = categoryEntityDictionary[categoryID] {
                    categoryEntity.addToAds(AdEntity.init(ad: ad, order: index, insertInto: context))
                    if index % 20 == 0 {
                        try context.save()
                    }
                }
            }
        
            try context.save()
        }
    }
    
    private func fetchStoredAdsList(offset: Int, limit: Int) async throws -> [Ad] {
        let ads: [Ad] = try await coreDateService.fetch(for: AdEntity.self,
                                                                    offset: offset,
                                                                    limit: limit)
        return ads
    }
}
