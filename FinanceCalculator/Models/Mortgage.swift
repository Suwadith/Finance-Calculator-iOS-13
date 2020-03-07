//
//  Mortgage.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/5/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation

class Mortgage {
    var loanAmount: Double
    var interest : Double
    var payment : Double
    var numberOfYears : Double
    var historyStringArray : [String]
    
    init(loanAmount: Double, interest: Double, payment: Double, numberOfYears: Double) {
        self.loanAmount = loanAmount
        self.interest = interest
        self.payment = payment
        self.numberOfYears = numberOfYears
        self.historyStringArray = [String]()
    }
    
    
    func calculateNumberOfYears() -> Double {
        self.numberOfYears = log(-self.payment/self.loanAmount*self.interest-self.payment)/log(self.interest+1)
        return self.numberOfYears
    }
    
    func calculateMonthlyPayment() -> Double {
        self.payment = (((self.interest/12) * self.loanAmount)  / (1-(pow(1+(self.interest/12), (self.numberOfYears * -12)))))
        return self.payment
    }
    
}
