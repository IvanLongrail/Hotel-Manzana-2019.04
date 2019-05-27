//
//  RoomType.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 18/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

struct RoomType: Codable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static var all: [RoomType] {
        return [
            RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
            RoomType(id: 1, name: "One King", shortName: "K", price: 209),
            RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309),
        ]
    }
}

// MARK: - Equatable
extension RoomType: Equatable {
    static func == (left: RoomType, right: RoomType) -> Bool {
        return left.id == right.id
    }
}
