//
//  CompoundSavingsViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class CompoundSavingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var presentValueField: UITextField!
    @IBOutlet weak var futureValueField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var numberOfYearsField: UITextField!
    @IBOutlet weak var compoundsPerYearField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    ///Creation of the custom keyboard object and initializing it with it's size parameters for the popup
    let keyboardView: KeyboardController = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    ///Creation of a CompoundSavings object
    var compoundSavings: CompoundSavings = CompoundSavings(presentValue: 0.0, futureValue: 0.0, interest: 0.0, numberOfYears: 0.0, compoundsPerYear: 12)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    ///Initialization of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("CompoundSavingsHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "CompoundSavings"
        populateTextFields()
    }
    
    
    ///Scrlls the view accordingly to avoid blocking text fields
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
        compoundSavings.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    ///Captures currently touched UITextField and sets  the custom keyboard as the default input device
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [presentValueField, futureValueField, interestField, numberOfYearsField, compoundsPerYearField]
        for tf in textFields {
            tf.styleTextField()
            tf.setCustomKeyboard(self.keyboardView)
            tf.assignDelegates(self)
            if tf == compoundsPerYearField {
                tf.greyedTextField()
            }
        }
    }
    
    ///Clears all the text fields (Except for the last one where the number of compounds is always a fixed value)
    func clearAllField() {
        for tf in 0..<self.textFields.count-1 {
            self.textFields[tf].clearField()
        }
    }
    
    ///Stores all the textfield values
    func storeTextFieldValues() {
        UserDefaults.standard.set(presentValueField.text, forKey: "compSavingspresentValueField")
        UserDefaults.standard.set(interestField.text, forKey: "compSavingsinterestField")
        UserDefaults.standard.set(futureValueField.text, forKey: "compSavingsfutureValueField")
        UserDefaults.standard.set(numberOfYearsField.text, forKey: "compSavingsnumberOfYearsField")
    }
    
    ///Populates the appropriate textfields with previously used values
    func populateTextFields() {
        presentValueField.text =  UserDefaults.standard.string(forKey: "compSavingspresentValueField")
        interestField.text =  UserDefaults.standard.string(forKey: "compSavingsinterestField")
        futureValueField.text =  UserDefaults.standard.string(forKey: "compSavingsfutureValueField")
        numberOfYearsField.text =  UserDefaults.standard.string(forKey: "compSavingsnumberOfYearsField")
    }
    
    
    ///Writes all the  current textfield values to the persistant storage
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let historyString = " 1. Present Value - \(compoundSavings.presentValue) \n 2. Future Value - \(compoundSavings.futureValue) \n 3. Interest Rate (%) - \(compoundSavings.interest) \n 4. Number of Years - \(compoundSavings.numberOfYears)  \n 5. Number of Compounds per Year - \(compoundSavings.compoundsPerYear)"
        
        compoundSavings.historyStringArray.append(historyString)
        defaults.set(compoundSavings.historyStringArray, forKey: "CompoundSavingsHistory")
    }
    
    ///Calculates the appropriate values requested y the user
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if presentValueField.checkIfEmpty() == true && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            
            presentValueField.text = String(compoundSavings.calculatePresentValue())
            storeTextFieldValues()
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            //            compoundSavings.payment = 0.0
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            
            futureValueField.text = String(compoundSavings.calculateFutureValue())
            storeTextFieldValues()
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            //            compoundSavings.payment = 0.0
            
            interestField.text = String(compoundSavings.calculateCompoundInterestRate())
            storeTextFieldValues()
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == true {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            //            compoundSavings.payment = 0.0
            
            numberOfYearsField.text = String(compoundSavings.calculateNumberOfYears())
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
