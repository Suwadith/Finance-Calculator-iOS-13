//
//  Double+Round.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/8/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    
    
    /**
     Rounds double values to a 2 decimal point
     * Reference: https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift/32581409#32581409
    */
    func roundTo2() -> Double {
        let divisor = pow(10.0, 2.0)
        let rounded = (self * divisor).rounded() / divisor
        return rounded
    }
    
    
}
