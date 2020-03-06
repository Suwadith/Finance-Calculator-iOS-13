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
    
//    @IBAction func onTfValueChanged(_ sender: UITextField) {
//        guard let textFieldValue = sender.text else { return }
//        guard let doubleTextFieldValue = Double(textFieldValue) else { return }
//
//
//        switch MortgageUnits(rawValue: sender.tag)! {
//
//        case .loanAmount:
//            mortgage.loanAmount = doubleTextFieldValue
//
//        case .interest:
//            mortgage.interest = doubleTextFieldValue
//
//        case .payment:
//            mortgage.payment = doubleTextFieldValue
//
//        case .numberOfYears:
//            mortgage.numberOfYears = doubleTextFieldValue
//
//        }
//
//    }
    
    func customizeTextFields() {
        
        textFields = [loanAmountField, interestField, paymentField, numberOfYearsField]

        for tf in textFields {
            tf.styleTextField()
            tf.setCustomKeyboard(self.keyboardView)
            tf.assignDelegates(self)
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
            showAlert(title: "Error", msg: "3 of the text fields have to be filled")
        }else if loanAmountField.checkIfEmpty() == false && interestField.checkIfEmpty() == false && paymentField.checkIfEmpty() == false {
            
            let l = Double(loanAmountField.text!)
            let i = Double(interestField.text!)
            let p = Double(paymentField.text!)
            
            let lineOne = log(-p!/((l!*i!)-p!))
            let linetwo = log(i!+1)
            
            let out = lineOne/linetwo
            
            numberOfYearsField.text = String(out)
            
            print(lineOne)
            print(linetwo)
            
        } else {
            showAlert(title: "Error", msg: "Calculation can only occur when 3 text fields are filled")
        }
        
    }
    
    
}

