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
    @IBOutlet weak var presentValueField: UITextField!
    @IBOutlet weak var futureValueField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var paymentsPerWeekField: UITextField!
    @IBOutlet weak var compoundsPerYearField: UITextField!
    @IBOutlet weak var paymentTime: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var loans: Loans = Loans(presentValue: 0.0, futureValue: 0.0, interest: 0.0, payment: 0.0, numberOfPaymentsPerYear: 0.0, compoundsPerYear: 0.0)
    
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
            loans.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            keyboardView.activeTextField = textField
        }
        
        func customizeTextFields() {
            textFields = [presentValueField, futureValueField, interestField, paymentField, paymentsPerWeekField, compoundsPerYearField]
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
            let historyString = "\(loans.presentValue) loan amount | \(loans.futureValue) interest | \(loans.interest) payment | \(loans.payment) number of years | \(loans.numberOfPaymentsPerYear) number of years | \(loans.compoundsPerYear) number of years"

            loans.historyStringArray.append(historyString)
            defaults.set(loans.historyStringArray, forKey: "LoansHistory")
        }
    
    @IBAction func onCalculate(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        
        
        
    }
    
    
    
    @IBAction func onClear(_ sender: UIButton) {
        sender.pulsate()
        dismissKeyboard()
        clearAllField()
        
    }
    
}
