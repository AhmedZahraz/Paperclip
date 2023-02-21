//
//  Category+Stub.swift
//  PaperclipTests
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import Foundation

extension Category {
    static func stub(id: Int64 = 1,
                     name: String = "name1") -> Self {
        Category(id: id, name: name)
    }
}
