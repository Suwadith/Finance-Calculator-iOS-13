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
    
    /**
     Calculates the principal loan amount
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * principal_loan_amount = (monthly_payment * (pow((1 + monthly_interest_rate), number_of_months) - 1)) / (monthly_interest_rate * pow((1 + monthly_interest_rate), number_of_months))
     * [Reference](https://www.calculatorsoup.com/calculators/financial/mortgage-calculator.php)
    */
    func calculateLoanAmount() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = 12 * self.numberOfYears
        let loan = (self.payment * (pow((1 + monthlyInterestRate), numberOfMonths) - 1)) / (monthlyInterestRate * pow((1 + monthlyInterestRate), numberOfMonths))
        
        self.loanAmount = loan.roundTo2()
        return self.loanAmount
    }
    
    func calculateAnnualInterestRate() -> Double {
        let numberOfMonths = 12 * self.numberOfYears
        var x = 1 + (((self.payment*numberOfMonths/self.loanAmount) - 1) / 12) // initial guess
        // var x = 0.1;
        let FINANCIAL_PRECISION = Double(0.000001) // 1e-6
        
        func F(_ x: Double) -> Double { // f(x)
            // (loan * x * (1 + x)^n) / ((1+x)^n - 1) - pmt
            return Double(self.loanAmount * x * pow(1 + x, numberOfMonths) / (pow(1+x, numberOfMonths) - 1) - payment);
        }
                            
        func FPrime(_ x: Double) -> Double { // f'(x)
            // (loan * (x+1)^(n-1) * ((x*(x+1)^n + (x+1)^n-n*x-x-1)) / ((x+1)^n - 1)^2)
            let c_derivative = pow(x+1, numberOfMonths)
            return Double(self.loanAmount * pow(x+1, numberOfMonths-1) *
                (x * c_derivative + c_derivative - (numberOfMonths*x) - x - 1)) / pow(c_derivative - 1, 2)
        }
        
        while(abs(F(x)) > FINANCIAL_PRECISION) {
            x = x - F(x) / FPrime(x)
        }

        // Convert to yearly interest & Return as a percentage
        // with two decimal fraction digits

        let I = Double(12 * x * 100)
        self.interest = I
        print("DEBUG", I)

        // if the found value for I is inf or less than zero
        // there's no interest applied
//        if I.isNaN || I.isInfinite || I < 0 {
//            return 0.0;
//        } else {
//          // this may return a value more than 100% for cases such as
//          // where payment = 2000, terms = 12, amount = 10000  <--- unreal figures
//          return I
//        }
        ///Todo
        return self.interest
    }
    
    /**
     Calculates the monthly payment value
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * number_of_months = number_of_years * 12
     * monthly_payment = (principal_loan_amount * monthly_interest_rate) / (1 - (pow((1 + monthly_interest_rate), number_of_months * -1)))
     * [Reference](https://www.calculatorsoup.com/calculators/financial/mortgage-calculator.php)
    */
    func calculateMonthlyPayment() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = 12 * self.numberOfYears
        let monthlyPayment = (self.loanAmount * monthlyInterestRate) / (1 - (pow((1 + monthlyInterestRate), numberOfMonths * -1)))
        self.payment = monthlyPayment.roundTo2()
        return self.payment
    }
    
    
    /**
     Calculates the number of years
     * monthly_interest_rate (in decimal) = (yearly_interest_rate / (12 * 100)
     * number_of_months = log((monthly_payment / monthly_interest_rate) / ((monthly_payment / monthly_interest_rate) - (principal_loan_amount))) / log(1 + monthly_interest_rate)
     * number_of_years = number_of_months / 12
     * [Reference](https://www.calculatorsoup.com/calculators/financial/mortgage-calculator.php)
    */
    func calculateNumberOfYears() -> Double {
        let monthlyInterestRate = self.interest / (12 * 100)
        let numberOfMonths = log((self.payment / monthlyInterestRate) / ((self.payment / monthlyInterestRate) - (self.loanAmount))) / log(1 + monthlyInterestRate)
        self.numberOfYears = (numberOfMonths / 12).roundTo2()
        return self.numberOfYears
    }
    
}
