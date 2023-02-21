//
//  AdDTO.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

struct AdDTO: Decodable {
    let id: Int64
    let title: String?
    let categoryID: Int64?
    let creationDate: String?
    let adDescription: String?
    let isUrgent: Bool?
    let imagesURL: ImagesURLDTO?
    let price: Float?
    let siret: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryID = "category_id"
        case creationDate = "creation_date"
        case adDescription = "description"
        case isUrgent = "is_urgent"
        case imagesURL = "images_url"
        case price
        case siret
    }
}

// MARK: - Mappings to Domain

extension AdDTO {
    func toDomain() -> Ad {
        return .init(id: id, title: title, category: nil, creationDate: creationDate, adDescription: adDescription, isUrgent: isUrgent, imagesURL: imagesURL?.toDomain(), price: price, siret: siret)
    }
}

extension AdDTO {
    struct ImagesURLDTO: Decodable {
        let small: String?
        let thumb: String?
        
        private enum CodingKeys: String, CodingKey {
            case small
            case thumb
        }
        
        func toDomain() -> ImagesURL {
            return .init(small: small, thumb: thumb)
        }
    }
}
