//
//  CoreDataService.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import Foundation
import CoreData

enum CoreDataStorageError: Error {
    case general
    case readError(Error?)
    case saveError(Error)
    case deleteError(Error)
}

class CoreDateService {
    
    private let dataModelName: String
    
    // MARK: - CoreData stack
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Init
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
    
    // MARK: - CoreData Save
    func save<T>(item: T, toEntity: (T, NSManagedObjectContext) -> NSManagedObject) async throws {
        return try await withUnsafeThrowingContinuation { [weak self] continuation in
            do {
                guard let context = self?.persistentContainer.viewContext else {
                    return continuation.resume(throwing: CoreDataStorageError.general)
                }
                let _ = toEntity(item, context)
                try context.save()
                continuation.resume(returning: ())
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - CoreData Fetch
    func fetch<D, T: ManagedObjectConvertible>(for entity: T.Type,
                                               offset: Int,
                                               limit: Int,
                                               sortKey: String? = T.sortKey,
                                               toDomain: @escaping (T) -> D = { itemT in itemT.toDomain() }) async throws -> [D] where T.U == D {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        if let key = sortKey {
            request.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
        }

        request.fetchOffset = offset
        request.fetchLimit = limit
                
        return try await withUnsafeThrowingContinuation { [weak self] continuation in
            guard let self = self else { return continuation.resume(throwing: CoreDataStorageError.general) }
            do {
                let result = try self.persistentContainer.viewContext.fetch(request)
                continuation.resume(returning: result.map {
                    return toDomain($0) })
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - CoreData Get
    func get<D, T: ManagedObjectConvertible>(for entity: T.Type,
                                               id: Int64,
                                               toDomain: @escaping (T) -> D = { itemT in itemT.toDomain() }) async throws -> D where T.U == D {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = NSPredicate(format: "id == %@", id)
                
        return try await withUnsafeThrowingContinuation { [weak self] continuation in
            guard let self = self else { return continuation.resume(throwing: CoreDataStorageError.general) }
            do {
                let result = try self.persistentContainer.viewContext.fetch(request)
                if let firstItem = result.first {
                    continuation.resume(returning: toDomain(firstItem))
                } else {
                    continuation.resume(throwing: CoreDataStorageError.readError(nil))
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func get<D, T: ManagedObjectConvertible>(for entity: T.Type,
                                               id: Int64,
                                               toDomain: @escaping (T) -> D = { itemT in itemT.toDomain() },
                                             context: NSManagedObjectContext) throws -> D where T.U == D {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = NSPredicate(format: "id == %lld", id)
        //NSPredicate(format: "id == %@", id)
              
        let result = try context.fetch(request)
        if let firstItem = result.first {
            return toDomain(firstItem)
        } else {
            throw CoreDataStorageError.readError(nil)
        }
    }
    
    // MARK: - CoreData Clear
    func clear(_ entity: NSManagedObject.Type, context: NSManagedObjectContext) throws {
        guard let entityName = entity.entity().name else {
            throw CoreDataStorageError.general
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
    }
    
    // MARK: - Core Data Saving support
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    // MARK: - CoreData PerformBackgroundTask async
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> (T)) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                do {
                    let result = try block(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
