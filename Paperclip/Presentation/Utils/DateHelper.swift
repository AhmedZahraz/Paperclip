//
//  DateHelper.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 21/02/2023.
//

import Foundation

class DateHelper {
    
    static func formatted(_ stringDate: String?,
                          inputDateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ",
                          outputDateFormat: String = "EEEE, MMM d, yyyy") -> String? {
        guard let stringDate = stringDate else {
            return nil
        }

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputDateFormat

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputDateFormat

        if let date = dateFormatterGet.date(from: stringDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            return stringDate
        }
    }
}
