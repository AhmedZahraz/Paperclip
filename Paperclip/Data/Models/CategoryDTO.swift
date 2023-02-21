//
//  CategoryDTO.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import Foundation

struct CategoryDTO: Decodable {
    let id: Int64
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

// MARK: - Mappings to Domain

extension CategoryDTO {
    func toDomain() -> Category {
        return .init(id: id, name: name)
    }
}
