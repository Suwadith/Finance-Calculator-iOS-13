//
//  File.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/5/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
     Hides the keyboard when touching outside of a textfield area
     * [Reference](https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift)
    */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    /// Closes the popup keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
