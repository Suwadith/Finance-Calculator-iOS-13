//
//  LoansViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class LoansViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loanAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var numberOfPaymentsField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var loan: Loan = Loan(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfPayments: 0)
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("LoansHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "Loans"
    }
    
    override func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name ==  UIResponder.keyboardWillChangeFrameNotification {
            ///scroll the view and prevent hiding the current selected text field
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        } else {
            ///get back to the deafult position when tapped away
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        loan.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    func customizeTextFields() {
        textFields = [loanAmountField, interestField, paymentField, numberOfPaymentsField]
        for tf in textFields {
            tf.styleTextField()
            tf.setCustomKeyboard(self.keyboardView)
            tf.assignDelegates(self)
            //            tf.glowEmptyTextFields()
        }
    }
    
    func clearAllField() {
        for tf in self.textFields {
            tf.clearField()
        }
    }
    
    
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let historyString = "\(loan.loanAmount) loan amount | \(loan.interest) interest | \(loan.payment) payment | \(loan.numberOfPayments) number of payments"
        
        loan.historyStringArray.append(historyString)
        defaults.set(loan.historyStringArray, forKey: "LoansHistory")
    }
    
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == true && paymentField.checkIfEmpty() == true && numberOfPaymentsField.checkIfEmpty() == true {
            
            showAlert(title: "Error", msg: "3 of the inputs have to be given")
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == true{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.interest = Double(interestField.text!)!
            loan.payment = Double(paymentField.text!)!
            
            numberOfPaymentsField.text = String(loan.calculateNumberOfPayments())
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.interest = Double(interestField.text!)!
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            
            paymentField.text = String(loan.calculateMonthlyPayment())
            
        } else if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            loan.interest = Double(interestField.text!)!
            loan.payment = Double(paymentField.text!)!
            
            loanAmountField.text = String(loan.calculateLoanAmount())
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            loan.payment = Double(paymentField.text!)!
            
            interestField.text = String(loan.calculateAnnualInterestRate())
            
            
        } else {
            showAlert(title: "Error", msg: "Calculation can only occur when 3 inputs are filled")
        }
        
    }
    
    
    
    @IBAction func onClear(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        clearAllField()
        
    }
    
}
