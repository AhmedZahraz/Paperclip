//
//  AdEntity+ManagedObjectConvertible.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import CoreData

extension AdEntity: ManagedObjectConvertible {
    
    typealias U = Ad
    
    static var sortKey: String? = "index"
    static var identifierKey: String = "id"

    func toDomain() -> Ad {
        Ad.init(id: self.id, title: self.title, category: self.category?.toDomain(), creationDate: self.creationDate, adDescription: self.adDescription, isUrgent: self.isUrgent, imagesURL: .init(small: self.smallImageURL, thumb: self.thumbImageURL) , price: self.price, siret: self.siret)
        
    }
}


extension AdEntity {
    convenience init(ad: Ad, categoryEntity: CategoryEntity, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = ad.id
        title = ad.title
        smallImageURL = ad.imagesURL?.small
        thumbImageURL = ad.imagesURL?.thumb
        category = categoryEntity
        
        creationDate = ad.creationDate
        adDescription = ad.adDescription
        isUrgent = ad.isUrgent ?? false
        price = ad.price ?? 0
        siret = ad.siret
    }
    
    convenience init(ad: AdDTO, categoryEntity: CategoryEntity, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = ad.id
        title = ad.title
        smallImageURL = ad.imagesURL?.small
        thumbImageURL = ad.imagesURL?.thumb
        category = categoryEntity
        
        creationDate = ad.creationDate
        adDescription = ad.adDescription
        isUrgent = ad.isUrgent ?? false
        price = ad.price ?? 0
        siret = ad.siret
    }
    
    convenience init(ad: AdDTO, order: Int, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = ad.id
        title = ad.title
        smallImageURL = ad.imagesURL?.small
        thumbImageURL = ad.imagesURL?.thumb
        index = Int16(order)
        
        creationDate = ad.creationDate
        adDescription = ad.adDescription
        isUrgent = ad.isUrgent ?? false
        price = ad.price ?? 0
        siret = ad.siret
    }
}
