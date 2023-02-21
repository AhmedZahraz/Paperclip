//
//  AdDetails.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 21/02/2023.
//

import Foundation

struct AdDetails: Hashable {
    let id: Int64
    let title: String?
    let categoryName: String?
    let creationDate: String?
    let isUrgent: Bool?
    let imageURL: String?
    let price: String?
    let description: String?
    
    init(from ad: Ad) {
        let adItem = AdItem(from: ad)
        
        id = adItem.id
        title = adItem.title
        categoryName = adItem.categoryName
        creationDate = adItem.creationDate
        isUrgent = adItem.isUrgent
        imageURL = ad.imagesURL?.thumb
        price = adItem.price
        description = ad.adDescription
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: AdDetails, rhs: AdDetails) -> Bool {
        return lhs.id == rhs.id
    }
}
