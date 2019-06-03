//
//  String.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 30/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

extension String {
    var isEmail: Bool {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return !emailPredicate.evaluate(with: self)
    }
    
    var isName: Bool {
        let nameRegex = "([A-Za-z ]){1,40}"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return !namePredicate.evaluate(with: self)
    }
}
