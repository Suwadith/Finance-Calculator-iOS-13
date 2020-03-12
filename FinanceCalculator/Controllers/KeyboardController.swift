//
//  KeyboardController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/29/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

enum KeyboardButton: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine, period, delete, negation
}
class KeyboardController: UIView {
    
    var currentView = ""
    
    @IBOutlet weak var keyboardBtn1: UIButton!
    @IBOutlet weak var keyboardBtn2: UIButton!
    @IBOutlet weak var keyboardBtn3: UIButton!
    @IBOutlet weak var keyboardBtn4: UIButton!
    @IBOutlet weak var keyboardBtn5: UIButton!
    @IBOutlet weak var keyboardBtn6: UIButton!
    @IBOutlet weak var keyboardBtn7: UIButton!
    @IBOutlet weak var keyboardBtn8: UIButton!
    @IBOutlet weak var keyboardBtn9: UIButton!
    @IBOutlet weak var keyboardBtnPoint: UIButton!
    @IBOutlet weak var keyboardBtn0: UIButton!
    @IBOutlet weak var keyboardBtnDelete: UIButton!
    
    var keyboardButtons = [UIButton()]
    
    ///Popup keyboard initialization
    ///Credit: https://stackoverflow.com/questions/33474771/a-swift-example-of-custom-views-for-data-input-custom-in-app-keyboard/33692231#33692231
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
        styleKeyboardButtons()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
        styleKeyboardButtons()
    }

    func initializeSubviews() {
        let xibFileName = "Keyboard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func styleKeyboardButtons() {
        keyboardButtons = [keyboardBtn0, keyboardBtn1, keyboardBtn2, keyboardBtn3, keyboardBtn4, keyboardBtn5, keyboardBtn6, keyboardBtn7, keyboardBtn8, keyboardBtn9, keyboardBtnPoint, keyboardBtnDelete]
        
        for button in keyboardButtons {
            button.styleKeyboardButtons()
        }
        
    }
    
    var activeTextField = UITextField()

    @IBAction func keyTapped(sender: UIButton) {
        
        let cursorPosition = getCursorPosition()
        
        if let currentText = self.activeTextField.text {
            switch KeyboardButton(rawValue: sender.tag)!{
            case .period:
                if !currentText.contains("."), currentText.count != 0 {
                    activeTextField.insertText(".")
                    setCursorPosition(from: cursorPosition)
                }
            case .delete:
                if currentText.count != 0 {
                    self.activeTextField.text?.remove(at: currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1))
                    
                    if String(currentText[currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1)]) != "." {
                        activeTextField.sendActions(for: UIControl.Event.editingChanged)
                    }
                    
                    setCursorPosition(from: cursorPosition, offset: -1)
                }
                
            default:
                activeTextField.insertText(String(sender.tag))
                setCursorPosition(from: cursorPosition)
            }
        }
        
    }
    
    func getCursorPosition() -> Int {
        guard let selectedRange = activeTextField.selectedTextRange else {return 0}
        return activeTextField.offset(from: activeTextField.beginningOfDocument, to: selectedRange.start)
    }
    
    func setCursorPosition(from:Int, offset: Int = 1) {
        if let newPosition = activeTextField.position(from: activeTextField.beginningOfDocument, offset: from + offset) {
            activeTextField.selectedTextRange = activeTextField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    

}



