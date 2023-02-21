//
//  CurrencyHelper.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 21/02/2023.
//

import Foundation

class CurrencyHelper {
    
    static func formatted(_ price: Float?,
                           locale: Locale = Locale(identifier: "fr_FR")) -> String? {
        guard let price = price else {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let formattedTipAmount = formatter.string(from: Int(price) as NSNumber) {
            return formattedTipAmount
        }
        
        return String(price)
    }
}
