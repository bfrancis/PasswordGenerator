//
//  MainViewController.swift
//  Password Generator
//
//  Created by Brad Francis on 9/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    let DEBUG = false
    
    var numPasswordsCounter = 1
    var numPasswordsFormatter = IntegerOnlyFormatter()
    var passwords = [Password]()
    
    @IBOutlet weak var numPasswordsTextField: NSTextField!
    @IBOutlet weak var numPasswordsStepper: NSStepper!
    
    @IBAction func stepperValueChanged(sender: NSStepper) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
        
        debug("Counter: " + String(numPasswordsCounter))
        debug("Stepper: " + String(numPasswordsStepper.integerValue))
    }
    
    
    @IBAction func textEntered(sender: NSTextField) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
        
        debug("Text Entered: " + sender.stringValue)
        debug("Formatter Minimum: " + numPasswordsFormatter.minimum.stringValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Formatter
        numPasswordsFormatter.minimum = 1
        numPasswordsFormatter.maximum = 9999
        
        // Bind formatter to text field
        numPasswordsTextField.formatter = numPasswordsFormatter
        
        numPasswordsStepper.maxValue = Double(numPasswordsFormatter.maximum)
        numPasswordsStepper.minValue = Double(numPasswordsFormatter.minimum)
        
        // "Bind" `numPasswordsCounter` to both the text field
        // and the stepper
        updateCounterControls()
    }
    
    func debug(message: String) {
        if DEBUG {
            println(message)
        }
    }
    
    func updateCounterControls() {
        numPasswordsStepper.integerValue = numPasswordsCounter
        numPasswordsTextField.integerValue = numPasswordsCounter
    }

    
}
