//
//  IndexPath.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 22/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension IndexPath {
    var prevRow: IndexPath {
        let row = self.row - 1
        let section = self.section
        
        return IndexPath(row: row, section: section)
    }
    
    var nextRow: IndexPath {
        let row = self.row + 1
        let section = self.section
        
        return IndexPath(row: row, section: section)
    }
}
