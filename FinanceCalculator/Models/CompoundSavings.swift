//
//  CompundSavings.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//
// All these equations were tested using: https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php

import Foundation

class CompoundSavings {
    
    var presentValue: Double
    var futureValue : Double
    var interest : Double
    var numberOfYears : Double
    var compoundsPerYear : Int
    var historyStringArray : [String]
    
    init(presentValue: Double, futureValue: Double, interest: Double, numberOfYears: Double, compoundsPerYear : Int) {
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interest = interest
        self.numberOfYears = numberOfYears
        self.compoundsPerYear = compoundsPerYear
        self.historyStringArray = [String]()
    }
    
    /**
     Calculates current savings value
     * annual_interest_rate (in decimal) = yearly_interest_rate / 100
     * current_principal_value  = future_value / pow(1 + (annual_interest_rate / number_of_compounds_per_year), number_of_compounds_per_year * number_of_years)
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
     */
    func calculatePresentValue() -> Double {
        let annualInterestRate = self.interest / 100
        let principalValue = self.futureValue / pow(1 + (annualInterestRate / Double(self.compoundsPerYear)), Double(self.compoundsPerYear) * self.numberOfYears)
        
       if principalValue < 0 || principalValue.isNaN || principalValue.isInfinite {
            self.presentValue = 0.0;
            return self.presentValue
        } else {
            self.presentValue = principalValue.roundTo2()
            return self.presentValue
        }
        
    }
    
    
    /**
     Calculates future savings value
     * annual_interest_rate (in decimal) = yearly_interest_rate / 100
     * future_value  = current_principal_value * pow(1 + (annual_interest_rate / number_of_compounds_per_year), number_of_compounds_per_year * number_of_years)
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
    */
    func calculateFutureValue() -> Double {
        let annualInterestRate = self.interest / 100
        let futureValue = self.presentValue * pow(1 + (annualInterestRate / Double(self.compoundsPerYear)), Double(self.compoundsPerYear) * self.numberOfYears)
        
        if futureValue < 0 || futureValue.isNaN || futureValue.isInfinite {
            self.futureValue = 0.0;
            return self.futureValue
        } else {
            self.futureValue = futureValue.roundTo2()
            return self.futureValue
        }
        
    }
    
    /**
     Calculates compound interest rate
     * decimal_interest_rate_value  =  number_of_compounds_per_year * (pow((future_value / current_principal_value), (1 / (number_of_compounds_per_year * number_of_years))) - 1)
     * annual_interest_rate = decimal_interest_rate_value * 100
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
    */
    func calculateCompoundInterestRate() -> Double {
        let interestRate = Double(self.compoundsPerYear) * (pow((self.futureValue / self.presentValue), (1 / (Double(self.compoundsPerYear) * self.numberOfYears))) - 1)
        
        if interestRate < 0 || interestRate.isNaN || interestRate.isInfinite {
            self.interest = 0.0;
            return self.interest
        } else {
            let annualInterestRate = interestRate * 100
            self.interest = annualInterestRate.roundTo2()
            return self.interest
        }
        
        
    }
    
    /**
     Calculates future savings value
     * annual_interest_rate (in decimal) = (yearly_interest_rate / 100
     * number_of_years = log(future_value / current_principal_value) / (number_of_compounds_per_year * log(1 + (annual_interest_rate / number_of_compounds_per_year)))
     * [Reference](https://www.thecalculatorsite.com/articles/finance/compound-interest-formula.php)
    */
    func calculateNumberOfYears() -> Double {
        let annualInterestRate = self.interest / 100
        let years = log(self.futureValue / self.presentValue) / (Double(self.compoundsPerYear) * log(1 + (annualInterestRate / Double(self.compoundsPerYear))))
        
        if years < 0 || years.isNaN || years.isInfinite {
            self.numberOfYears = 0.0;
            return self.numberOfYears
        } else {
            self.numberOfYears = years.roundTo2()
            return self.numberOfYears
        }
        
        
    }
    
}
