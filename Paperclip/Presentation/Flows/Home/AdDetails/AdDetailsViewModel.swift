//
//  AdDetailsViewModel.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import Foundation

enum AdState: Hashable {
    case none
    case loading
    case success(ad: AdDetails)
    case error
}

protocol AdDetailsViewModel {
    var adStatePublisher: Published<AdState>.Publisher { get }
    func loadAd(id: Int64)
}

class DefaultAdDetailsViewModel: AdDetailsViewModel {
        
    private let getAdUseCase: GetAdUseCase
    
    @Published private var adState: AdState
    var adStatePublisher: Published<AdState>.Publisher { $adState }
    
    init(getAdUseCase: GetAdUseCase) {
        self.getAdUseCase = getAdUseCase
        self.adState = .none
    }
    
    func loadAd(id: Int64) {
        Task {
            do {
                adState = .loading
                let ad = try await getAdUseCase.execute(id: id)
                print("Fetched Ad ID \(ad.id)")
                adState = .success(ad: AdDetails(from: ad))
            } catch {
                adState = .error
                print("Fetching Ad Details failed with error \(error)")
            }
        }
    }
}
