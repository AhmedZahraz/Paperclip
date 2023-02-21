//
//  GetAdUseCase.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import Foundation

protocol GetAdUseCase {
    func execute(id: Int64) async throws -> Ad
}

final class DefaultGetAdUseCase: GetAdUseCase {

    private let adRepository: AdRepository

    init(adRepository: AdRepository) {
        self.adRepository = adRepository
    }

    func execute(id: Int64) async throws -> Ad {
        return try await adRepository.getAd(with: id)
    }
}
