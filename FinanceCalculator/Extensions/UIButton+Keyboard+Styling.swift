//
//  UIButton+Keyboard+Styling.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/12/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    ///Styling custom keyboard buttons
    func styleKeyboardButtons() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = tintColor.cgColor
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
}
