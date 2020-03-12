//
//  UIButton+Styling.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/6/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    ///Styling Calculate Button
    func styleCalculateButton() {
        self.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    ///Styling Clear Button
    func styleClearButton() {
        self.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    /**
     On Button click perform a pulse like animation
     * [Reference](https://medium.com/better-programming/swift-uibutton-animations-6ce016212c6e)
     */
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    
    
}
