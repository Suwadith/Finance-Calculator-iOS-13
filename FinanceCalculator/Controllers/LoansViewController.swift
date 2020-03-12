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
    
    ///Creation of the custom keyboard object and initializing it with it's size parameters for the popup
    let keyboardView: KeyboardController = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    ///Creation of a Loan object
    var loan: Loan = Loan(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfPayments: 0)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    ///Initialization of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("LoansHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "Loans"
        populateTextFields()
        addTextFieldIcons()
    }
    
    ///Scrolls the view accordingly to avoid blocking text fields
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
    
    ///Uses UserDefaults to create a persistant storage for the app
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        loan.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    ///Captures currently touched UITextField and sets  the custom keyboard as the default input device
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [loanAmountField, interestField, paymentField, numberOfPaymentsField]
        for tf in textFields {
            tf.styleTextField()
            tf.setCustomKeyboard(self.keyboardView)
            tf.assignDelegates(self)
            tf.tintColor = UIColor.black
        }
    }
    
    ///Adds an icon at the beginning of a textfield
    func addTextFieldIcons() {
        loanAmountField.setIcon(UIImage(named: "money")!)
        interestField.setIcon(UIImage(named: "percentage")!)
        paymentField.setIcon(UIImage(named: "money")!)
        numberOfPaymentsField.setIcon(UIImage(named: "time")!)
    }
    
    ///Clears all the text fields
    func clearAllField() {
        for tf in self.textFields {
            tf.clearField()
        }
    }
    
    ///Stores all the textfield values
    func storeTextFieldValues() {
        UserDefaults.standard.set(loanAmountField.text, forKey: "loansloanAmountField")
        UserDefaults.standard.set(interestField.text, forKey: "loansinterestField")
        UserDefaults.standard.set(paymentField.text, forKey: "loanspaymentField")
        UserDefaults.standard.set(numberOfPaymentsField.text, forKey: "loansnumberOfPaymentsField")
    }
    
    ///Populates the appropriate textfields with previously used values
    func populateTextFields() {
        loanAmountField.text =  UserDefaults.standard.string(forKey: "loansloanAmountField")
        interestField.text =  UserDefaults.standard.string(forKey: "loansinterestField")
        paymentField.text =  UserDefaults.standard.string(forKey: "loanspaymentField")
        numberOfPaymentsField.text =  UserDefaults.standard.string(forKey: "loansnumberOfPaymentsField")
    }
    
    
    ///Writes all the  current textfield values to the persistant storage
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let historyString = " 1. Loan Amount - \(loan.loanAmount) \n 2. Interest Rate (%) - \(loan.interest) \n 3. Monthly Payment - \(loan.payment) \n 4. Number of Payments - \(loan.numberOfPayments)"
        
        loan.historyStringArray.append(historyString)
        defaults.set(loan.historyStringArray, forKey: "LoansHistory")
    }
    
    ///Calculates the appropriate values requested y the user
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == true{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.interest = Double(interestField.text!)!
            loan.payment = Double(paymentField.text!)!
            
            numberOfPaymentsField.text = String(loan.calculateNumberOfPayments())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.interest = Double(interestField.text!)!
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            
            paymentField.text = String(loan.calculateMonthlyPayment())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            loan.interest = Double(interestField.text!)!
            loan.payment = Double(paymentField.text!)!
            
            loanAmountField.text = String(loan.calculateLoanAmount())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfPaymentsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            loan.loanAmount = Double(loanAmountField.text!)!
            loan.numberOfPayments = Int(Double(numberOfPaymentsField.text!)!)
            loan.payment = Double(paymentField.text!)!
            
            interestField.text = String(loan.calculateAnnualInterestRate())
            storeTextFieldValues()
            
        } else {
            showAlert(title: "Error", msg: "Invalid Operation")
        }
        
    }
    
    
    ///Clears button function
    @IBAction func onClear(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        clearAllField()
        storeTextFieldValues()
    }
    
}
