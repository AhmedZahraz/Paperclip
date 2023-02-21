//
//  Ad.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 13/02/2023.
//

import Foundation

struct Ad: Hashable {
    let id: Int64
    let title: String?
    let category: Category?
    let creationDate: String?
    let adDescription: String?
    let isUrgent: Bool?
    let imagesURL: ImagesURL?
    let price: Float?
    let siret: String?
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Ad, rhs: Ad) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - ImagesURL
struct ImagesURL {
    let small, thumb: String?
}
