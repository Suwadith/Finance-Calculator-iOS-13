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
    @IBOutlet weak var paymentTime: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var compoundSavings: CompoundSavings = CompoundSavings(presentValue: 0.0, futureValue: 0.0, interest: 0.0, numberOfYears: 0.0, compoundsPerYear: 12)
    
    var textFields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("CompoundSavingsHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "CompoundSavings"
       
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
            compoundSavings.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            keyboardView.activeTextField = textField
        }
        
        func customizeTextFields() {
            textFields = [presentValueField, futureValueField, interestField, numberOfYearsField, compoundsPerYearField]
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
            let historyString = " 1. Present Value - \(compoundSavings.presentValue) \n 2. Future Value - \(compoundSavings.futureValue) \n 3. Interest Rate (%) - \(compoundSavings.interest) \n 4. Number of Years - \(compoundSavings.numberOfYears)  \n 5. Number of Compounds per Year - \(compoundSavings.compoundsPerYear)"
    
            compoundSavings.historyStringArray.append(historyString)
            defaults.set(compoundSavings.historyStringArray, forKey: "CompoundSavingsHistory")
        }
        
        
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if presentValueField.checkIfEmpty() == true && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            
            presentValueField.text = String(compoundSavings.calculatePresentValue())
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            //            compoundSavings.payment = 0.0
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            
            futureValueField.text = String(compoundSavings.calculateFutureValue())
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && numberOfYearsField.checkIfEmpty() == false {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsField.text!)!
            //            compoundSavings.payment = 0.0
            
            interestField.text = String(compoundSavings.calculateCompoundInterestRate())
            
        } else if presentValueField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && numberOfYearsField.checkIfEmpty() == true {
            
            compoundSavings.presentValue = Double(presentValueField.text!)!
            compoundSavings.futureValue = Double(futureValueField.text!)!
            compoundSavings.interest = Double(interestField.text!)!
            //            compoundSavings.payment = 0.0
            
            numberOfYearsField.text = String(compoundSavings.calculateNumberOfYears())
            
        } else {
            showAlert(title: "Error", msg: "Every field cannot be left empty")
            
        }
        
    }
        
        
        
        @IBAction func onClear(_ sender: UIButton) {
            sender.pulsate()
            dismissKeyboard()
            clearAllField()
            
        }
   

}
