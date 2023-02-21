//
//  ImageView+Network.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 21/02/2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(from stringURL: String?,
              with identifier: Int64,
              placeholderImage: UIImage? = ImageCache.placeholder,
              completion: @escaping (Int64, UIImage?) -> Swift.Void) {
        if let stringURL = stringURL, let url = URL(string: stringURL) {
            ImageCache.publicCache.load(url: url as NSURL, item: identifier) { (id, image) in
                completion(id, image ?? placeholderImage)
            }
        } else {
            completion(identifier, placeholderImage)
        }
    }
}
