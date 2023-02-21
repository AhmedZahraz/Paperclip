//
//  GetAdsWithCategoriesUseCaseTests.swift
//  PaperclipTests
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import Foundation

import XCTest
@testable import Paperclip

class GetAdsWithCategoriesUseCaseTests: XCTestCase {
    
    static let categories: [Category] = {
        let category1 = Category.stub(id: 1, name: "name1")
        let category2 = Category.stub(id: 2, name: "name2")
        
        return [category1, category2]
    }()
    
    static let ads: [Ad] = {
        let ad1 = Ad.stub(id: 1, title: "title1", category: categories.first)
        let ad2 = Ad.stub(id: 2, title: "title2", category: categories.last)
        let ad3 = Ad.stub(id: 3, title: "title3")
        let ad4 = Ad.stub(id: 4, title: "title4")
        
        return [ad1, ad2]
    }()
    
    func testGetAdsWithCategoriesUseCase_whenSuccessfullyFetchesAds_thenShouldReturnTheFetchedAds() async throws {
        // given
        let inputAds = GetAdsWithCategoriesUseCaseTests.ads
        let useCase = DefaultGetAdsWithCategoriesUseCase(adRepository: AdRepositoryMock(ads: inputAds),
                                                         categoryRepository: CategoryRepositoryMock(categories: GetAdsWithCategoriesUseCaseTests.categories))
        
        // when
        let offset: Int = 0
        let limit: Int = inputAds.count
        let result = try await useCase.execute(offset: offset, limit: limit)
        
        // then
        XCTAssertEqual(result, inputAds)
    }
    
    func testGetAdsWithCategoriesUseCase_whenFailedFetchingAds_thenShouldThrowError() async {
        // given
        let useCase = DefaultGetAdsWithCategoriesUseCase(adRepository: AdRepositoryThrowsMock(error: TestError.someExpectedError),
                                                         categoryRepository: CategoryRepositoryMock(categories: GetAdsWithCategoriesUseCaseTests.categories))
        
        // when
        let offset: Int = 0
        let limit: Int = 1
        
        // then
        do {
            _ = try await useCase.execute(offset: offset, limit: limit)
            XCTFail("This call should throw an error.")
        } catch {
            XCTAssertEqual(error as! TestError, TestError.someExpectedError)
        }
    }
    
    struct AdRepositoryMock: AdRepository {
        let ads: [Ad]
        
        func getAd(with id: Int64) async throws -> Ad {
            return ads.first { $0.id == id }!
        }
        
        func fetchAdsList(offset: Int, limit: Int) async throws -> [Ad] {
            return ads
        }
    }
    
    struct AdRepositoryThrowsMock: AdRepository {
        let error: Error
        
        func getAd(with id: Int64) async throws -> Ad {
            throw error
        }
        
        func fetchAdsList(offset: Int, limit: Int) async throws -> [Ad] {
            throw error
        }
    }
    
    struct CategoryRepositoryMock: CategoryRepository {
        let categories: [Category]
        
        func fetchCategoriesList() async throws -> [Category] {
            return categories
        }
    }
    
    enum TestError: Error {
        case someExpectedError
    }
}
