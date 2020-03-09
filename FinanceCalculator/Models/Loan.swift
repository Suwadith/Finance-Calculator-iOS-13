//
//  Loans.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import Foundation

class Loan {
    
    var loanAmount: Double
    var interest : Double
    var payment : Double
    var numberOfPayments : Int
    var historyStringArray : [String]
    
    init(loanAmount: Double, interest: Double, payment: Double, numberOfPayments: Int) {
        self.loanAmount = loanAmount
        self.interest = interest
        self.payment = payment
        self.numberOfPayments = numberOfPayments
        self.historyStringArray = [String]()
    }
    
    
    /**
     Calculates the principal loan amount
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * principal_loan_amount = (monthly_payment * (pow((1 + monthly_interest_rate), number_of_payments) - 1)) / (monthly_interest_rate * pow((1 + monthly_interest_rate), number_of_payments))
     * [Reference](https://www.calculatorsoup.com/calculators/financial/loan-calculator-simple.php)
    */
    func calculateLoanAmount() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let loan = (self.payment * (pow((1 + monthlyInterestRate), Double(numberOfPayments)) - 1)) / (monthlyInterestRate * pow((1 + monthlyInterestRate), Double(numberOfPayments)))
        
        if loan < 0 || loan.isNaN || loan.isInfinite {
            self.loanAmount = 0.0;
            return self.loanAmount
        } else {
            self.loanAmount = loan.roundTo2()
            return self.loanAmount
        }
    }
    
    func calculateAnnualInterestRate() -> Double {
        let numberOfMonths = Double(self.numberOfPayments)
        var x = 1 + (((self.payment*numberOfMonths/self.loanAmount) - 1) / 12)
        
        func F(_ x: Double) -> Double {
            let F = self.loanAmount * x * pow(1 + x, numberOfMonths) / (pow(1+x, numberOfMonths) - 1) - self.payment
            return F;
        }
        
        func F_Prime(_ x: Double) -> Double {
            let F_Prime = self.loanAmount * pow(x+1, numberOfMonths-1) * (x * pow(x+1, numberOfMonths) + pow(x+1, numberOfMonths) - (numberOfMonths*x) - x - 1) / pow(pow(x+1, numberOfMonths) - 1, 2)
            return F_Prime
        }
        
        while(abs(F(x)) > Double(0.000001)) {
            x = x - F(x) / F_Prime(x)
        }
        
        let I = Double(12 * x * 100)
        
        if I < 0 || I.isNaN || I.isInfinite {
            self.interest = 0.0;
            return self.interest
        } else {
            self.interest = I.roundTo2()
            return self.interest
        }
    }
    
    /**
     Calculates the monthly payment value
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * monthly_payment = (principal_loan_amount * monthly_interest_rate) / (1 - (pow((1 + monthly_interest_rate), number_of_payments * -1)))
     * [Reference](https://www.calculatorsoup.com/calculators/financial/loan-calculator-simple.php)
    */
    func calculateMonthlyPayment() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let monthlyPayment = (self.loanAmount * monthlyInterestRate) / (1 - (pow((1 + monthlyInterestRate), Double(numberOfPayments) * -1)))
        
        if monthlyPayment < 0 || monthlyPayment.isNaN || monthlyPayment.isInfinite {
            self.payment = 0.0;
            return self.payment
        } else {
            self.payment = monthlyPayment.roundTo2()
            return self.payment
        }
    }
    
    /**
     Calculates the number of payments
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * number_of_payments = log((monthly_payment / monthly_interest_rate) / ((monthly_payment / monthly_interest_rate) - (principal_loan_amount))) / log(1 + monthly_interest_rate)
     * [Reference](https://www.calculatorsoup.com/calculators/financial/loan-calculator-simple.php)
    */
    func calculateNumberOfPayments() -> Int {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = log((self.payment / monthlyInterestRate) / ((self.payment / monthlyInterestRate) - (self.loanAmount))) / log(1 + monthlyInterestRate)
        
        if numberOfMonths < 0 || numberOfMonths.isNaN || numberOfMonths.isInfinite {
            self.numberOfPayments = 0;
            return self.numberOfPayments
        } else {
            self.numberOfPayments = Int(numberOfMonths)
            return self.numberOfPayments
        }
        
        
    }
    
    
    
}
