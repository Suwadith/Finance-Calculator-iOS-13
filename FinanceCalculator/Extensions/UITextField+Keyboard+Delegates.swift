//
//  UITextField+Keyboard+Delegates.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/5/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Replaces the default keyboard with the custom keyboard for all the input views (text fields etc.)
    func setCustomKeyboard(_ customKeyboard: KeyboardController) {
        self.inputView = customKeyboard
    }
    
    func assignDelegates(_ viewController: UITextFieldDelegate) {
        self.delegate = viewController
    }
}
