//
//  AdsListViewModel.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 16/02/2023.
//

import Foundation
import Combine

enum AdsState: Hashable {
    case none
    case loading
    case success(ads: [AdItem])
    case error
}

protocol AdsListViewModel: AnyObject {
    var adsStatePublisher: Published<AdsState>.Publisher { get }
    
    func loadAds(offset: Int, limit: Int)
}

class DefaultAdsListViewModel: AdsListViewModel {
        
    private let getAdsWithCategoriesUseCase: GetAdsWithCategoriesUseCase
    
    @Published private var adsState: AdsState

    var adsStatePublisher: Published<AdsState>.Publisher { $adsState }
    
    init(getAdsWithCategoriesUseCase: GetAdsWithCategoriesUseCase) {
        self.getAdsWithCategoriesUseCase = getAdsWithCategoriesUseCase
        
        self.adsState = .none
    }
    
    func loadAds(offset: Int, limit: Int) {
        Task {
            do {
                adsState = .loading
                let ads = try await getAdsWithCategoriesUseCase.execute(offset: offset, limit: limit)
                print("Fetched \(ads.count) ads.")
                adsState = .success(ads: ads.map { AdItem(from: $0) })
            } catch {
                adsState = .error
                print("Fetching Ads failed with error \(error)")
            }
        }
    }
}
