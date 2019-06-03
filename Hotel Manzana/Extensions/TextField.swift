//
//  TextField.swift
//  Hotel Manzana
//
//  Created by Иван longrail on 31/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension UITextField {
    func setupFieldColor(if validationResult: Bool) {
        var willChange: Bool = validationResult
        if self.text!.isEmpty { willChange = true }
        self.layer.borderColor = willChange ? UIColor.groupTableViewBackground.cgColor : UIColor.red.cgColor
        self.layer.borderWidth = willChange ? 0.1 : 0.5
        self.layer.cornerRadius = 5
    }
}
