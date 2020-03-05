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
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
    
    var mortgage: Mortgage = Mortgage(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfYears: 0.0)
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDefaultsData("MortgageHistory")
        self.customizeTextFields()
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        
    }
    
    
    func addKeyboardEventListeners() {
        ///listening to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

        ///scroll the view and prevent hiding the current selected text field
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name ==  UIResponder.keyboardWillChangeFrameNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
            ///get back to the deafult position when tapped away
        } else {
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
    
    @IBAction func onTfValueChanged(_ sender: UITextField) {
        guard let textFieldValue = sender.text else { return }
        guard let doubleTextFieldValue = Double(textFieldValue) else { return }
        
    
        switch MortgageUnits(rawValue: sender.tag)! {
            
        case .loanAmount:
            mortgage.loanAmount = doubleTextFieldValue
//            interestField.text = "\(mortgage.interest)"
//            paymentField.text = "\(mortgage.payment)"
//            numberOfYearsField.text = "\(mortgage.numberOfYears)"
        case .interest:
            mortgage.interest = doubleTextFieldValue
//            loanAmountField.text = "\(mortgage.loanAmount)"
//            paymentField.text = "\(mortgage.payment)"
//            numberOfYearsField.text = "\(mortgage.numberOfYears)"
        case .payment:
            mortgage.payment = doubleTextFieldValue
//            interestField.text = "\(mortgage.interest)"
//            loanAmountField.text = "\(mortgage.loanAmount)"
//            numberOfYearsField.text = "\(mortgage.numberOfYears)"
        case .numberOfYears:
            mortgage.numberOfYears = doubleTextFieldValue
//            interestField.text = "\(mortgage.interest)"
//            paymentField.text = "\(mortgage.payment)"
//            loanAmountField.text = "\(mortgage.loanAmount)"
        }
        
    }
    
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
    

}

