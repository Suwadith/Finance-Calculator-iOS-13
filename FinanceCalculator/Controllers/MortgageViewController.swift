//
//  ViewController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/27/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var numberOfYears: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loanAmount.delegate = self
        loanAmount.uniqueTextField()
        interest.uniqueTextField()
        payment.uniqueTextField()
        numberOfYears.uniqueTextField()
    }
    
    
    
    @IBAction func loanAmountChanged(_ sender: Any) {
        
        interest.text = loanAmount.text
    }
    

}

extension UITextField {
    
    func uniqueTextField() {
//        self.backgroundColor = .blue
        self.layer.borderWidth = 1.5
    }
    
}

