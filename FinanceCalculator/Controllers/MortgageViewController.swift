//
//  ViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/27/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate, KeyboardDelegate {
    
    
    
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var numberOfYears: UITextField!
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loanAmount.delegate = self
//        loanAmount.inputView = keyboard
        setUITextFieldBorders()
        
        let keyboardView = KeyboardController(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped

        // replace system keyboard with custom keyboard
        loanAmount.inputView = keyboardView
    }
    
    func keyWasTapped(character: String) {
        loanAmount.insertText(character)
        print("Test")
    }
    
    func setUITextFieldBorders() {
        
        textFields = [loanAmount, interest, payment, numberOfYears]

        for tf in textFields {
            tf.styleTextField()
//            tf.enableCustomKeyboard(keyboard: keyboard)
        }
    }
    
    
    @IBAction func loanAmountChanged(_ sender: Any) {
        interest.text = loanAmount.text
    }
    

}

extension UITextField {

    func styleTextField() {
        self.layer.borderWidth = 1.5
    }
    
//    func enableCustomKeyboard(keyboard: KeyboardController) {
//        self.inputView = keyboard
//    }

}

