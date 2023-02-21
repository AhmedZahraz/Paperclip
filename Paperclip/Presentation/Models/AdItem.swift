//
//  AdItem.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 21/02/2023.
//

import Foundation

struct AdItem: Hashable {
    let id: Int64
    let title: String?
    let categoryName: String?
    let creationDate: String?
    let isUrgent: Bool?
    let smallImageURL: String?
    let price: String?
    
    init(from ad: Ad) {
        id = ad.id
        title = ad.title
        categoryName = ad.category?.name
        creationDate = DateHelper.formatted(ad.creationDate)
        isUrgent = ad.isUrgent
        smallImageURL = ad.imagesURL?.small
        price = CurrencyHelper.formatted(ad.price)
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: AdItem, rhs: AdItem) -> Bool {
        return lhs.id == rhs.id
    }
}
