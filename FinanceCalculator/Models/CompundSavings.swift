//
//  CompundSavings.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation

class CompoundSavings {
    
    var presentValue: Double
    var futureValue : Double
    var interest : Double
    var payment : Double
    var numberOfPaymentsPerYear : Double
    var compoundsPerYear : Double
    var historyStringArray : [String]
    
    init(presentValue: Double, futureValue: Double, interest: Double, payment: Double, numberOfPaymentsPerYear: Double, compoundsPerYear : Double) {
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interest = interest
        self.payment = payment
        self.numberOfPaymentsPerYear = numberOfPaymentsPerYear
        self.compoundsPerYear = compoundsPerYear
        self.historyStringArray = [String]()
    }
    
}
