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
    
    @IBOutlet weak var loanAmountField: UITextField!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var paymentField: UITextField!
    @IBOutlet weak var numberOfYearsField: UITextField!
    
    let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
    
    
    var mortgage: Mortgage = Mortgage(loanAmount: 0.0, interest: 0.0, payment: 0.0, numberOfYears: 0.0)
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("MortgageHistory")
        self.setUITextFieldBorders()
        self.assignInputView()
        hideKeyboardWhenTappedAround()
    }
    
    func assignDelegates() {
        loanAmountField.delegate = self
        interestField.delegate = self
        paymentField.delegate = self
        numberOfYearsField.delegate = self
    }
    
    //Replaces the default keyboard with the custom keyboard for all the text fields
    func assignInputView() {
        loanAmountField.inputView = keyboardView
        interestField.inputView = keyboardView
        paymentField.inputView = keyboardView
        numberOfYearsField.inputView = keyboardView
        
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
    
    func setUITextFieldBorders() {
        
        textFields = [loanAmountField, interestField, paymentField, numberOfYearsField]

        for tf in textFields {
            tf.styleTextField()
        }
    }
    
    
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let historyString = "\(mortgage.loanAmount) loan amount | \(mortgage.interest) interest | \(mortgage.payment) payment | \(mortgage.numberOfYears) number of years"
        
        mortgage.historyStringArray.append(historyString)
        defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
    }
    

}

extension UITextField {

    func styleTextField() {
        self.layer.borderWidth = 1.5
    }
    

}

