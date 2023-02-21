//
//  ManagedObjectConvertible.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import CoreData

protocol ManagedObjectConvertible: NSManagedObject {
    associatedtype U
    
    static var sortKey: String? { get }
    static var identifierKey: String { get }
    
    func toDomain() -> U
}
