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

    /// Adds a box border with a particular border width
    func styleTextField() {
        self.layer.borderWidth = 1.5
    }
    
    /// Clears text fields
    func clearField() {
        self.text = ""
    }
    
    func greyedTextField() {
        self.backgroundColor = UIColor.lightGray
    }
    
    /**
     Sets a custom icon inside the text field
     * [Reference](https://medium.com/nyc-design/swift-4-add-icon-to-uitextfield-48f5ebf60aa1)
     */
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 5, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
//    func glowEmptyTextFields() {
//        if self.text == "" {
//            self.layer.borderColor = UIColor.red.cgColor
//        } else {
//            self.layer.borderColor = UIColor.black.cgColor
//        }
//    }

}
