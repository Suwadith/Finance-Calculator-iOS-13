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
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = 12 * self.numberOfYears
        let loan = (self.payment * (pow((1 + monthlyInterestRate), numberOfMonths) - 1)) / (monthlyInterestRate * pow((1 + monthlyInterestRate), numberOfMonths))
        
        self.loanAmount = loan
        return loan
    }
    
    func calculateAnnualInterestRate() -> Double {
        
        func SolveForI(pa: Double, payment: Double, terms: Double) -> Double {
            
            var x = 1 + (((payment*terms/pa) - 1) / 12) // initial guess
            let f_p = Double(0.000001) // 1e-6
            
            func F(_ x: Double) -> Double {
                // (loan * x * (1 + x)^n) / ((1+x)^n - 1) - pmt
                return Double(pa * x * pow(1 + x, terms) / (pow(1+x, terms) - 1) - payment);
            }
            
            func F_Prime(_ x: Double) -> Double {
                // (loan * (x+1)^(n-1) * (x*(x+1)^n + (x+1)^n-n*x-x-1)) / ((x+1)^n - 1)^2
                let c_derivative = pow(x+1, terms)
                return Double(pa * pow(x+1, terms-1) *
                    (x * c_derivative + c_derivative - (terms*x) - x - 1)) / pow(c_derivative - 1, 2)
            }
            
            while(abs(F(x)) > f_p) {
                x = x - F(x) / F_Prime(x) // issue here
            }
            
            return x;
            
        }
        ///Todo
        return self.interest
    }
    
    func calculateMonthlyPayment() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = 12 * self.numberOfYears
        let monthlyPayment = (self.loanAmount * monthlyInterestRate) / (1 - (pow((1 + monthlyInterestRate), numberOfMonths * -1)))
        self.payment = monthlyPayment
        return self.payment
    }
    
    func calculateNumberOfYears() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = log((self.payment / monthlyInterestRate) / ((self.payment / monthlyInterestRate) - (self.loanAmount))) / log(1 + monthlyInterestRate)
        self.numberOfYears = numberOfMonths / 12
        return self.numberOfYears
    }
    
}
