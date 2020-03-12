//
//  ViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/27/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loanAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var numberOfYearsField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    ///Creation of the custom keyboard object and initializing it with it's size parameters for the popup
    let keyboardView: KeyboardController = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    ///Creation of a Mortgage object
    var mortgage: Mortgage = Mortgage(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfYears: 0.0)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    ///Initialization of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("MortgageHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "Mortgage"
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
        mortgage.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    ///Captures currently touched UITextField and sets  the custom keyboard as the default input device
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [loanAmountField, interestField, paymentField, numberOfYearsField]
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
        numberOfYearsField.setIcon(UIImage(named: "time")!)
    }
    
    ///Clears all the text fields
    func clearAllField() {
        for tf in self.textFields {
            tf.clearField()
        }

    }
    
    ///Stores all the textfield values
    func storeTextFieldValues() {
        UserDefaults.standard.set(loanAmountField.text, forKey: "mortgageloanAmountField")
        UserDefaults.standard.set(interestField.text, forKey: "mortgageinterestField")
        UserDefaults.standard.set(paymentField.text, forKey: "mortgagepaymentField")
        UserDefaults.standard.set(numberOfYearsField.text, forKey: "mortgagenumberOfYearsField")
    }
    
    ///Populates the appropriate textfields with previously used values
    func populateTextFields() {
        loanAmountField.text =  UserDefaults.standard.string(forKey: "mortgageloanAmountField")
        interestField.text =  UserDefaults.standard.string(forKey: "mortgageinterestField")
        paymentField.text =  UserDefaults.standard.string(forKey: "mortgagepaymentField")
        numberOfYearsField.text =  UserDefaults.standard.string(forKey: "mortgagenumberOfYearsField")
    }
    
    
    ///Writes all the  current textfield values to the persistant storage
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let historyString = " 1. Mortgage Value - \(mortgage.loanAmount) \n 2. Interest Rate (%) - \(mortgage.interest)  \n 3. Monthly Payment - \(mortgage.payment) \n 4. Number of Years (Time) - \(mortgage.numberOfYears)"
        
        mortgage.historyStringArray.append(historyString)
        defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
    }
    
    ///Calculates the appropriate values requested y the user
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == true{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            numberOfYearsField.text = String(mortgage.calculateNumberOfYears())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            
            paymentField.text = String(mortgage.calculateMonthlyPayment())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            mortgage.interest = Double(interestField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            loanAmountField.text = String(mortgage.calculateLoanAmount())
            storeTextFieldValues()
            
        } else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfYearsField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false{
            
            
            mortgage.loanAmount = Double(loanAmountField.text!)!
            mortgage.numberOfYears = Double(numberOfYearsField.text!)!
            mortgage.payment = Double(paymentField.text!)!
            
            interestField.text = String(mortgage.calculateAnnualInterestRate())
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

