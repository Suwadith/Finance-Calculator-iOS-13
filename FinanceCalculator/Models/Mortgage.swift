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
    
    func calculateLoanAmount() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100);
        let numberOfMonths = 12 * self.numberOfYears;
        let loan = (self.payment * (pow((1 + monthlyInterestRate), numberOfMonths) - 1)) / (monthlyInterestRate * pow((1 + monthlyInterestRate), numberOfMonths))
        
        self.loanAmount = loan
        return loan
    }
    
    func calculateAnnualInterestRate() -> Double {
        ///Todo
        return self.interest
    }
    
    func calculateMonthlyPayment() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100);
        let numberOfMonths = 12 * self.numberOfYears;
        let monthlyPayment = (self.loanAmount * monthlyInterestRate) / (1 - (pow((1 + monthlyInterestRate), numberOfMonths * -1)));
        self.payment = monthlyPayment
        return self.payment
    }
    
    func calculateNumberOfYears() -> Double {
        ///Todo
        return self.numberOfYears
    }
    
}
