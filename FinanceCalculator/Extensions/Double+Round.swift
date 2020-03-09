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
    
    func roundTo2() -> Double {
        let divisor = pow(10.0, 2.0)
        let rounded = (self * divisor).rounded() / divisor
        return rounded
    }
    
    
}
