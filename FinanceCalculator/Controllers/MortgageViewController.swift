//
//  ViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/27/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

enum MortgageUnits: Int {
    case loanAmount, interest, payment, numberOfYears
}

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loanAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var numberOfYearsField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var mortgage: Mortgage = Mortgage(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfYears: 0.0)
    
    var textFields = [UITextField]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("MortgageHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "Mortgage"
        
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
        mortgage.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    func customizeTextFields() {
        textFields = [loanAmountField, interestField, paymentField, numberOfYearsField]
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
        let historyString = "\(mortgage.loanAmount) loan amount | \(mortgage.interest) interest | \(mortgage.payment) payment | \(mortgage.numberOfYears) number of years"
        
        mortgage.historyStringArray.append(historyString)
        defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
    }
    
    
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == true && paymentField.checkIfEmpty() == true && numberOfYearsField.checkIfEmpty() == true {
            
            showAlert(title: "Error", msg: "3 of the inputs have to be given")
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == true{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            numberOfYearsField.text = String(mortgage.calculateNumberOfYears())
            
        }else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            
            paymentField.text = String(format: "%.2f", mortgage.calculateMonthlyPayment())
            
            }else if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            loanAmountField.text = String(format: "%.2f", mortgage.calculateLoanAmount())
            
            }else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            interestField.text = String(format: "%.2f", mortgage.calculateAnnualInterestRate())
            
            
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

