//
//  Test.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/6/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
     Listens to keyboard events
     * [Reference](https://www.youtube.com/watch?v=xVZubAMFuIU)
    */
    func addKeyboardEventListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){}
    
}
