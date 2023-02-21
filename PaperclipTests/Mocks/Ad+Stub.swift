//
//  Ad+Stub.swift
//  PaperclipTests
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import Foundation

extension Ad {
    static func stub(id: Int64 = 1,
                     title: String = "title1",
                     category: Category? = nil) -> Self {
        Ad(id: id,
           title: title,
           category: category,
           creationDate: nil,
           adDescription: nil,
           isUrgent: nil,
           imagesURL: nil,
           price: nil,
           siret: nil)
    }
}
