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
    var numberOfYears : Double
    var compoundsPerYear : Double
    var historyStringArray : [String]
    
    init(presentValue: Double, futureValue: Double, interest: Double, payment: Double, numberOfYears: Double, compoundsPerYear : Double) {
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interest = interest
        self.payment = payment
        self.numberOfYears = numberOfYears
        self.compoundsPerYear = compoundsPerYear
        self.historyStringArray = [String]()
    }
    
    func calculatePresentValue() -> Double {
            let annualInterestRate = self.interest / 100
            let principalValue = self.futureValue / pow(1 + (annualInterestRate / self.compoundsPerYear), self.compoundsPerYear * self.numberOfYears)
            self.presentValue = principalValue.roundTo2()
            return self.presentValue
        }
        
        func calculateFutureValue() -> Double {
            let annualInterestRate = self.interest / 100
            let futureValue = self.presentValue * pow(1 + (annualInterestRate / self.compoundsPerYear), self.compoundsPerYear * self.numberOfYears)
            self.futureValue = futureValue.roundTo2()
            return self.futureValue
        }
        
        func calculateCompoundInterestRate() -> Double {
            
           ///TODO use Yasin's code
            return self.interest
            
        }
        
        func calculatePayment() -> Double {
        
            return self.payment
        }
        
        
        func calculateNumberOfYears() -> Double {
            let annualInterestRate = self.interest / 100
    //        print(log(self.futureValue / self.presentValue))
    //        print(self.compoundsPerYear * log(1 + (annualInterestRate / self.compoundsPerYear)))
            let years = log(self.futureValue / self.presentValue) / (self.compoundsPerYear * log(1 + (annualInterestRate / self.compoundsPerYear)))
    //        print(years)
            self.numberOfYears = years.roundTo2()
    //        print(self.numberOfYears)
            return self.numberOfYears
        }
        
        func calculateCompoundsPerYear() -> Double {
            self.compoundsPerYear = 12 ///Default
            return self.compoundsPerYear
        }
    
}
