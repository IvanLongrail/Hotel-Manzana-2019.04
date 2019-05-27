//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 18/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

struct Registration: Codable {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
}

extension Registration {
    
    var encode: Data? {
        let encoder = PropertyListEncoder()
        
        return try? encoder.encode(self)
    }
    
    static func getGuestRegistrationData(from data: Data) -> Registration? {
        let decoder = PropertyListDecoder()
        
        guard let guest = try? decoder.decode(Registration.self, from: data) else {return nil}
        
        return guest
    }
}

extension Registration {
    func totalPrice(wifiPricePerDay: Int) -> Int{
        let daysNumber = checkInDate.numberOfDays(between: checkOutDate)
        let price = wifi ? (roomType.price + wifiPricePerDay) * daysNumber : roomType.price * daysNumber
        return price
    }
}
