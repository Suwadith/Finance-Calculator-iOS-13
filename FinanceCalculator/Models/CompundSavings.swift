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
    
    /**
     Calculates current savings value
     * annual_interest_rate (in decimal) = (yearly_interest_rate / 100
     * current_principal_value  = future_value / pow(1 + (annual_interest_rate / number_of_compounds_per_year), number_of_compounds_per_year * number_of_years)
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
     */
    func calculatePresentValue() -> Double {
        let annualInterestRate = self.interest / 100
        let principalValue = self.futureValue / pow(1 + (annualInterestRate / self.compoundsPerYear), self.compoundsPerYear * self.numberOfYears)
        self.presentValue = principalValue.roundTo2()
        return self.presentValue
    }
    
    
    /**
     Calculates future savings value
     * annual_interest_rate (in decimal) = (yearly_interest_rate / 100
     * future_value  = current_principal_value * pow(1 + (annual_interest_rate / number_of_compounds_per_year), number_of_compounds_per_year * number_of_years)
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
    */
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
    
    /**
     Calculates future savings value
     * annual_interest_rate (in decimal) = (yearly_interest_rate / 100
     * number_of_years = log(future_value / current_principal_value) / (number_of_compounds_per_year * log(1 + (annual_interest_rate / number_of_compounds_per_year)))
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
    */
    func calculateNumberOfYears() -> Double {
        let annualInterestRate = self.interest / 100
        let years = log(self.futureValue / self.presentValue) / (self.compoundsPerYear * log(1 + (annualInterestRate / self.compoundsPerYear)))
        self.numberOfYears = years.roundTo2()
        return self.numberOfYears
    }
    
    func calculateCompoundsPerYear() -> Double {
        self.compoundsPerYear = 12 ///Default
        return self.compoundsPerYear
    }
    
}
