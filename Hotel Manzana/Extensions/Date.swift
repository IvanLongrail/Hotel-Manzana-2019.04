//
//  Date.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 12/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

extension Date {
    func numberOfDays(between secondDate: Date, _ calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.day], from: self, to: secondDate).day!
    }
    
    var guestListDateFormatString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
}
