//
//  Savings.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation

class Savings {
    
    var principalAmount: Double
    var interest : Double
    var payment : Double
    var compoundsPerYear : Double
    var paymentsPerYear : Double
    var futureValue : Double
    var totalNumberOfPayments: Double
    var historyStringArray : [String]
    
    init(principalAmount: Double, interest: Double, payment: Double, compoundsPerYear: Double, paymentsPerYear: Double, futureValue: Double, totalNumberOfPayments: Double) {
        self.principalAmount = principalAmount
        self.interest = interest
        self.payment = payment
        self.compoundsPerYear = compoundsPerYear
        self.paymentsPerYear = paymentsPerYear
        self.futureValue = futureValue
        self.totalNumberOfPayments = totalNumberOfPayments
        self.historyStringArray = [String]()
    }
    
    
    
    
}
