//
//  CategoryEntity+ManagedObjectConvertible.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import CoreData

extension CategoryEntity: ManagedObjectConvertible {    
    typealias U = Category
    
    static var sortKey: String? = nil
    static var identifierKey: String = "id"

    func toDomain() -> Category {
        Category(id: self.id, name: self.name!)
    }
}

extension CategoryEntity {
    convenience init(category: Category, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = category.id
        name = category.name
    }
}
