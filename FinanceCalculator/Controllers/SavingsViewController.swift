//
//  SavingsViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 3/7/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var principalAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var compoundsPerYearField: UITextField!
    @IBOutlet weak var paymentsPerYearField: UITextField!
    @IBOutlet weak var futureValueField: UITextField!
    @IBOutlet weak var totalNoOfPaymentsField: UITextField!
    
    
    @IBOutlet weak var calculationTime: UILabel!
    
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    ///Creation of the custom keyboard object and initializing it with it's size parameters for the popup
    let keyboardView: KeyboardController = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    ///Creation of a Savings object
    var savings: Savings = Savings(principalAmount: 0.0, interest: 0.0, payment: 0.0, compoundsPerYear: 12, paymentsPerYear: 12, futureValue: 0.0, totalNumberOfPayments: Int(0.0))
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    ///Initialization of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("SavingsHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        calculateButton.styleCalculateButton()
        clearButton.styleClearButton()
        self.keyboardView.currentView = "Savings"
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
        savings.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    ///Captures currently touched UITextField and sets  the custom keyboard as the default input device
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [principalAmountField, interestField, paymentField, futureValueField, totalNoOfPaymentsField, compoundsPerYearField, paymentsPerYearField]
        for tf in textFields {
            tf.styleTextField()
            tf.setCustomKeyboard(self.keyboardView)
            tf.assignDelegates(self)
            if tf == compoundsPerYearField || tf == paymentsPerYearField{
                tf.greyedTextField()
            }
            tf.tintColor = UIColor.black
        }
    }
    
    ///Adds an icon at the beginning of a textfield
    func addTextFieldIcons() {
        principalAmountField.setIcon(UIImage(named: "money")!)
        interestField.setIcon(UIImage(named: "percentage")!)
        paymentField.setIcon(UIImage(named: "money")!)
        futureValueField.setIcon(UIImage(named: "money")!)
        totalNoOfPaymentsField.setIcon(UIImage(named: "time")!)
        compoundsPerYearField.setIcon(UIImage(named: "scale")!)
        paymentsPerYearField.setIcon(UIImage(named: "scale")!)
    }
    
    ///Clears all the text fields
    func clearAllField() {
        for tf in 0..<self.textFields.count-2 {
            self.textFields[tf].clearField()
        }
    }
    
    ///Stores all the textfield values
    func storeTextFieldValues() {
        UserDefaults.standard.set(principalAmountField.text, forKey: "savingspresentValueField")
        UserDefaults.standard.set(interestField.text, forKey: "savingsinterestField")
        UserDefaults.standard.set(paymentField.text, forKey: "savingspaymentField")
        UserDefaults.standard.set(futureValueField.text, forKey: "savingsfutureValueField")
        UserDefaults.standard.set(totalNoOfPaymentsField.text, forKey: "savingstotalNoOfPaymentsField")
    }
    
    ///Populates the appropriate textfields with previously used values
    func populateTextFields() {
        principalAmountField.text =  UserDefaults.standard.string(forKey: "savingspresentValueField")
        interestField.text =  UserDefaults.standard.string(forKey: "savingsinterestField")
        paymentField.text =  UserDefaults.standard.string(forKey: "savingspaymentField")
        futureValueField.text =  UserDefaults.standard.string(forKey: "savingsfutureValueField")
        totalNoOfPaymentsField.text =  UserDefaults.standard.string(forKey: "savingstotalNoOfPaymentsField")
    }
    
    ///Changes the label according to the switch movements
    @IBAction func onTimeChange(_ sender: UISwitch) {
        if(timeSwitch.isOn) {
            calculationTime.text = "End"
        } else {
            calculationTime.text = "Beginning"
        }
        
    }
    
    ///Writes all the  current textfield values to the persistant storage
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        
        ///Makes sure that none of the textfields are empty
        if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
            
            ///Makes sure that the object is not holding empty values
            if(savings.principalAmount != 0 && savings.interest != 0 && savings.payment != 0 && savings.futureValue != 0 && savings.totalNumberOfPayments != 0) {
                
                let defaults = UserDefaults.standard
                let historyString = " 1. Principal Amount - \(savings.principalAmount) \n 2. Interest Rate (%) - \(savings.interest) \n 3. Deposit - \(savings.payment) \n 4. Number of Compounds per Year - \(savings.compoundsPerYear)  \n 5. Number of Deposits per Year - \(savings.paymentsPerYear) \n 6. Future Value - \(savings.futureValue) \n 7. Total number of Deposits - \(savings.totalNumberOfPayments) \n 8. Deposit made at the - \(calculationTime.text!)"
                
                ///Resets the object to default values as soon as a save operation is done (to prevent re-saving values without making another calculation)
                (savings.principalAmount, savings.interest, savings.payment, savings.futureValue, savings.totalNumberOfPayments) = (0,0,0,0,0)
                
                ///Makes sure that the history list only holds last 5 calculations
                if(savings.historyStringArray.count > 4) {
                    savings.historyStringArray.removeFirst()
                    savings.historyStringArray.append(historyString)
                    defaults.set(savings.historyStringArray, forKey: "SavingsHistory")
                } else {
                    savings.historyStringArray.append(historyString)
                    defaults.set(savings.historyStringArray, forKey: "SavingsHistory")
                }
                
            } else {
                showAlert(title: "Error", msg: "Cannot save values without making a valid calculation")
            }
            
        } else {
            showAlert(title: "Error", msg: "Cannot save values with empty fields")
        }
        
    }
    
    ///Calculates the appropriate values requested y the user
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        if(calculationTime.text) == "End" {
            
            if principalAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                principalAmountField.text = String(savings.calculateEndPrincipalAmount())
                storeTextFieldValues()
                
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                paymentField.text = String(savings.calculateEndPayment())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == true && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                futureValueField.text = String(savings.calculateEndFutureValue())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == true {
                
                savings.interest = Double(interestField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                
                totalNoOfPaymentsField.text = String(savings.calculateEndNumberOfPayments())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                
                interestField.text = String(savings.calculateInterest())
                storeTextFieldValues()
                
            
            } else {
                showAlert(title: "Error", msg: "Invalid Operation")
                
            }
            
        } else {
            
            if principalAmountField.checkIfEmpty() == true && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                principalAmountField.text = String(savings.calculateBeginningPrincipalAmount())
                storeTextFieldValues()
                
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == true && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                paymentField.text = String(savings.calculateBeginningPayment())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == true && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.interest = Double(interestField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                
                futureValueField.text = String(savings.calculateBeginningFutureValue())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == true {
                
                savings.interest = Double(interestField.text!)!
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                
                totalNoOfPaymentsField.text = String(savings.calculateBeginningNumberOfPayments())
                storeTextFieldValues()
                
            
            } else if principalAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == true && futureValueField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false && totalNoOfPaymentsField.checkIfEmpty() == false {
                
                savings.totalNumberOfPayments = Int(Double(totalNoOfPaymentsField.text!)!)
                savings.payment = Double(paymentField.text!)!
                savings.principalAmount = Double(principalAmountField.text!)!
                savings.futureValue = Double(futureValueField.text!)!
                
                interestField.text = String(savings.calculateInterest())
                storeTextFieldValues()
                
            
            } else {
                showAlert(title: "Error", msg: "Invalid Operation")
                
            }
            
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
