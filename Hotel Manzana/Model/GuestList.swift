//
//  GuestList.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 14/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

struct GuestList: Codable {
    var currentGuests: [Registration]
    var archiveGuests: [Registration]
    
    init() {
        currentGuests = [Registration]()
        archiveGuests = [Registration]()
    }
    
    mutating func add(_ newGuest: Registration) {
        
        self.currentGuests.insert(newGuest, at: getCurrentGuestIndex(for: newGuest))
    }
    
    private func getCurrentGuestIndex(for newGuest: Registration) -> Int {
        var index = 0
        currentGuests.forEach {
            index += newGuest.checkOutDate > $0.checkOutDate ? 1 : 0
        }
        return index
    }
    
    mutating func change(at index: Int, by guest: Registration) {
        self.currentGuests.remove(at: index)
        add(guest)
    }
    
    mutating func addToArchive(from index: Int) {
        let newArchiveGuest = self.currentGuests[index]
        self.archiveGuests.append(newArchiveGuest)
        self.currentGuests.remove(at: index)
    }
    
    mutating func remove(from index: Int) {
        self.archiveGuests.remove(at: index)
    }
    
    mutating func removeAll() {
        self.archiveGuests.removeAll()
    }
}

extension GuestList {
    var encode: Data? {
        let encoder = PropertyListEncoder()
        
        return  try? encoder.encode(self)
    }
    
    static func getGuestList(from data: Data) -> GuestList? {
        let decoder = PropertyListDecoder()
        
        guard let guestList = try? decoder.decode(GuestList.self, from: data) else {return nil}
        
        return guestList
    }
}
