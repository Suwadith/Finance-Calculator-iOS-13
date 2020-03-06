//
//  UITextField+Validations.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func checkIfEmpty() -> Bool{
        if self.text!.count > 0 {
            return false
        } else {
            return true
        }
    }
    
}
