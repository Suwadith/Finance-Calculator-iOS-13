//
//  KeyboardController.swift
//  FinanceCalculator
//
//  Created by Suwadith on 2/29/20.
//  Copyright © 2020 Suwadith. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class KeyboardController: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    let nibName = "Keyboard"
//    var contentView:UIView?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        guard let view = loadViewFromNib() else { return }
//        view.frame = self.bounds
//        self.addSubview(view)
//        contentView = view
//    }
//
//    func loadViewFromNib() -> UIView? {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
    
    weak var delegate: KeyboardDelegate?

    // MARK:- keyboard initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }

    func initializeSubviews() {
        let xibFileName = "Keyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }

    // MARK:- Button actions from .xib file

    @IBAction func keyTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!) // could alternatively send a tag value
//        print("Test")
    }

}
