//
//  UITextField+Styling.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/5/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    func styleTextField() {
        self.layer.borderWidth = 1.5
    }
    
    func clearField() {
        self.text = ""
    }
    
//    func glowEmptyTextFields() {
//        if self.text == "" {
//            self.layer.borderColor = UIColor.red.cgColor
//        } else {
//            self.layer.borderColor = UIColor.black.cgColor
//        }
//    }

}
