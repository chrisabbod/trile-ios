//
//  DateFormatterManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/17/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import Foundation

class DateFormatterManager {

    static func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    static func formatStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.date(from: dateString)
        
        return formattedDate!
    }
}
